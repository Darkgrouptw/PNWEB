class DetaillistController < ApplicationController
    before_filter :authenticate_user!, only: [:new, :create, :thumb]
    
	def index
		@all_detail = true
		@tags = params[:detail_id]
		@detail = DataDetail.where(id: @tags)
		if @detail.where(id: @tags).length >= 1
			
			@me = @detail.where(id: @tags)[0]
			@issue = DataIssue.where(id: @me.issue_id)[0]
			@person = DataPerson.where(id: @me.people_id)[0]
			@user = User.where(id: @me.post_id)[0]
			@likeDislikeList = LikeDislikeList.where(post_id: current_user)
			if !@me.comment_id.nil? && !@me.comment_id.empty?
				@strings = @me.comment_id.split(/,/)
				@comments = DataComment.where(id: @strings).order(:created_at).reverse
				@strings2 = Array.new
				@comments.each do |comment|
					@strings2.push(comment.post_id)
				end
				@talkers = User.where(id: @strings2)
			end
			
			@all_detail = false
		else
			@all_detail = true
		end
	end

	def new
		@comment = DataComment.new
	end

	def create
		@comment = DataComment.create(comment_params)
		@comment.post_id = current_user.id
		if @comment.save
			@tags = params[:detail_id]
			@detail = DataDetail.where(:id => @tags)[0]
			@detail.comment_id = @detail.comment_id + @comment.id.to_s + ","
			@detail.update(comment_id: @detail.comment_id)
			redirect_to detaillist_path+"/"+@tags
		else
			render :new
		end
    end
    
    def thumb
    	#that user vote the detail 
    	#notes!! this function isn't check the issue is been vote by user for over 3 times
    	@detail = DataDetail.where(id: params[:detail_id])[0]
    	@likeDislikeLists = LikeDislikeList.where(detail_id: @detail.id)
    	has_vote = false
    	@likeDislikeLists.each do |likeDislikeList|
    		if likeDislikeList.post_id = params[:current_user]
    			has_vote = true
    		end
    	end
    	if has_vote
    		#do something if the user have already vote this detail
    		if(params[:from_issue] != nil && params[:from_issue] == "true")
        	#http://localhost:3000/issuelist/1/1/0
        		redirect_to "/issuelist/" + params[:issue_id] + "/" + params[:postive_page] + "/" + params[:negative_page]
        	else
        		redirect_to "/detaillist/"+params[:detail_id]
    		end
    		return
    	end
    	#create new  like_dislike_list item
    	time = Time.new
    	@newLike_dislike_list = LikeDislikeList.new
    	@newLike_dislike_list.update(created_at: time.inspect,
    		detail_id: @detail.id,
    		is_like: (params[:thumb] == "1") ? true : false,
    		post_id: params[:current_user])

    	#update details like_dislike_list
    	like_dislike_list = @detail.like_dislike_list_id
    	if like_dislike_list == nil
    		like_dislike_list = ""
    	end
    	like_dislike_list = like_dislike_list.split("|")
    	like_list = ""
    	dislike_list = ""
    	if like_dislike_list.length == 2
    		like_list = like_dislike_list[0]
    		dislike_list = like_dislike_list[1]
    	end

        if params[:thumb] == "1"
            flash[:notice] = "推成功！！"
            if like_list.length == 0
            	like_list = @newLike_dislike_list.id.to_s
            else
            	like_list = like_list + "," + @newLike_dislike_list.id.to_s
            end
            #@detail.update(count_like: @detail.count_like + 1)
        elsif params[:thumb] == "0"
            flash[:notice] = "不推成功！！"
            if dislike_list.length == 0
            	dislike_list = @newLike_dislike_list.id.to_s
            else
            	dislike_list = dislike_list + "," + @newLike_dislike_list.id.to_s
            end
            #@detail.update(count_dislike: @detail.count_dislike + 1)
        else
            flash[:notice] = "失敗！！"
        end
        @detail.update(like_dislike_list_id: like_list + "|" + dislike_list)
        #http://localhost:3000/detaillist/19/thumb?from_issue=true&issue_id=1&negative_page=0&postive_page=1&thumb=1
        if(params[:from_issue] != nil && params[:from_issue] == "true")
        	#http://localhost:3000/issuelist/1/1/0
        	redirect_to "/issuelist/" + params[:issue_id] + "/" + params[:postive_page] + "/" + params[:negative_page]
        else
        	redirect_to "/detaillist/"+params[:detail_id]
    	end
        #"detaillist/" + params[:detail_id]
    end

    def thumb_cancel
    	
    	@likeDislikeLists = LikeDislikeList.where(detail_id: params[:detail_id]).where(post_id: params[:current_user])
    	list_id = @likeDislikeLists[0].id
    	@detail = DataDetail.where(id: params[:detail_id])[0]
    	#update detaile's list
    	like_dislike_list = @detail.like_dislike_list_id
    	if like_dislike_list == nil
    		like_dislike_list = ""
    	end
    	like_dislike_list = like_dislike_list.split("|")
    	like_list = ""
    	dislike_list = ""
    	like_list_item = []
    	dislike_list_item = []
    	if like_dislike_list.length == 0
    	elsif like_dislike_list.length == 1
    		like_list_item = like_dislike_list[0].split(",")
    	else
    		like_list_item = like_dislike_list[0].split(",")
    		dislike_list_item = like_dislike_list[1].split(",")
    	end
    	
    	
    	like_list_item.each do |item|
    		is_first = true
    		if item.to_i != list_id
    			if is_first
    				like_list = like_list + item
    			else
    				like_list = like_list + "," + item
    			end
    		end
    	end
    	dislike_list_item.each do |item|
    		is_first = true
    		if item.to_i != list_id
    			if is_first
    				dislike_list = dislike_list + item
    			else
    				dislike_list = dislike_list + "," + item
    			end
    		end
    	end
    	@detail.update(like_dislike_list_id: like_list + "|" + dislike_list)
    	#kill vote data
    	@likeDislikeLists.destroy_all
    	#redirect
    	if(params[:from_issue] != nil && params[:from_issue] == "true")
        	#http://localhost:3000/issuelist/1/1/0
        	redirect_to "/issuelist/" + params[:issue_id] + "/" + params[:postive_page] + "/" + params[:negative_page]
        else
        	redirect_to "/detaillist/"+params[:detail_id]
    	end
    	
    end
    def detail_params
        params.require(:data_detail).permit(:is_support, :content, :link, :count, :count_dislike, :post_id, :people_id, :issue_id, :comment_id, :comment_id, :issue_id)
    end
    
    def issue_params
        params.require(:data_detail).permit(:datadetail)
    end

    def comment_params
    	params.require(:data_comment).permit(:content)
    end
end

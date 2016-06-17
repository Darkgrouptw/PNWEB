class DetaillistController < ApplicationController
	def index
		@all_detail = true
		@tags = params[:detail_id]
		@detail = DataDetail.where(id: @tags)
		if @detail.where(id: @tags).length >= 1
			
			@me = @detail.where(id: @tags)[0]
			@issue = DataIssue.where(id: @me.issue_id)[0]
			@person = DataPerson.where(id: @me.people_id)[0]
			@user = User.where(id: @me.post_id)[0]
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
    	@detail = DataDetail.where(id: params[:detail_id])[0]
        if params[:thumb] == "1"
            flash[:notice] = "推成功！！"
            @detail.update(count_like: @detail.count_like + 1)
        elsif params[:thumb] == "0"
            flash[:notice] = "不推成功！！"
            @detail.update(count_dislike: @detail.count_dislike + 1)
        else
            flash[:notice] = "失敗！！"
        end
        #http://localhost:3000/detaillist/19/thumb?from_issue=true&issue_id=1&negative_page=0&postive_page=1&thumb=1
        if(params[:from_issue] != nil && params[:from_issue] == "true")
        	#http://localhost:3000/issuelist/1/1/0
        	redirect_to "/issuelist/" + params[:issue_id] + "/" + params[:postive_page] + "/" + params[:negative_page]
        else
        	redirect_to "/detaillist/"+params[:detail_id]
    	end
        #"detaillist/" + params[:detail_id]
    end

    def detail_params
        params.require(:data_detail).permit(:is_support, :content, :link, :count, :count_like, :count_dislike, :post_id, :people_id, :issue_id, :comment_id, :comment_id, :issue_id)
    end
    
    def issue_params
        params.require(:data_detail).permit(:datadetail)
    end

    def comment_params
    	params.require(:data_comment).permit(:content)
    end
end

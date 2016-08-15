class IssuelistController < ApplicationController

	def index
		@tags = params[:id]
		@issues = DataIssue.all.order(:created_at)
		@me = @issues.where(id: @tags)[0]
		if @me ==nil
			return
		end
		detail_strings = @me.datadetail_id.split(',')
		@details = DataDetail.where(id: detail_strings)
		@likeList = LikeList.where(post_id: current_user)
		# 判斷是否讚太多
		likeLimit = 3
		likeNumber = 0
		@NoMoreLike = false
		@details.each do |detail|
			like = @likeList.where(detail_id: detail.id)[0]
			if !like.nil?
				likeNumber = likeNumber + 1
			end
		end
		if likeNumber >= likeLimit
			@NoMoreLike = true
		end
		# 要判斷是用什麼來排序
		if params[:orderby] == "Time"
			@support = @details.where(is_support: true).order(:created_at).reverse
			@disSupport = @details.where(is_support: false).order(:created_at).reverse
		else
			@support = @details.where(is_support: true)
			@disSupport = @details.where(is_support: false)
			# 計算讚數來以排序 boble sort
			for i in 0..@support.length - 1
				length_i = 0
				text_i = @support[i].like_list_id
				length_i = text_i.split(',').length
				for j in 0..i
					length_j = 0
					text_j = @support[i].like_list_id
					length_j = text_j.split(',').length

					if length_j < length_i
						temp = @support[i]
						@support[i] = @support[j]
						@support[j] = temp
					end
				end
			end
			for i in 0..@disSupport.length - 1
				length_i = 0
				text_i = @disSupport[i].like_list_id
				length_i = text_i.split(',').length
				for j in 0..i
					length_j = 0
					text_j = @disSupport[i].like_list_id
					length_j = text_j.split(',').length

					if length_j < length_i
						temp = @disSupport[i]
						@disSupport[i] = @disSupport[j]
						@disSupport[j] = temp
					end
				end
			end
		end
		#判斷顯示的頁數
		@numberPerPage = 5
        @PageExtend = 2
		@negative_page = 0
		@positive_page = 0
		if(params[:positive_page] != nil)
		    @positive_page = params[:positive_page] 
		end
		if(params[:negative_page] != nil)
		    @negative_page = params[:negative_page]
		end
		@PositiveHasNextPage = true
        @PositiveHasLastPage = false
        @NegativeHasNextPage = true
        @NegativeHasLastPage = false
        if(@positive_page.to_i > 0)
            @PositiveHasLastPage = true
        end
        if(@negative_page.to_i > 0)
            @NegativeHasLastPage = true
        end
        if( (@negative_page.to_i + 1 ) * @numberPerPage > @disSupport.length)
            @NegativeHasNextPage = false
        end
        if( (@positive_page.to_i + 1 ) * @numberPerPage > @support.length)
            @PositiveHasNextPage = false
        end

        #增加名人 編者
        user = []
		person = []
        for i in 0..@numberPerPage-1
            index = @numberPerPage * @positive_page.to_i + i
            if(@support.length > index)
                user.push(@support[index].post_id)
                person.push(@support[index].people_id)
            end
            index = @numberPerPage * @negative_page.to_i + i
            if(@disSupport.length > index)
                user.push(@disSupport[index].post_id)
                person.push(@disSupport[index].people_id)
            end
        end

        #update Notify
        if !current_user.nil?
        	@notifyList =  NotifyList.where(user_id: current_user.id , issue_id: @me.id)[0]
        	if !@notifyList.nil?
        		@notifyList.last_read = Time.now
        		@notifyList.save
        	end
        end
        @users=User.where(id: user)
        @persons=DataPerson.where(id: person)
	end

	def add

	end

	def new
		title = params[:title]
		post = params[:post]
		trunk_id = params[:trunk_id]
		tag = params[:tag]
		

		@issue = DataIssue.create(created_at: Time.now,updated_at: Time.now)
		@issue.title = title
		@issue.post = post
		if trunk_id.nil? || trunk_id.empty?
			@issue.trunk_id = -1;
		else
			@issue.trunk_id = trunk_id
		end
		@issue.tag = tag
		@issue.is_candidate = true
		@issue.popularity = 0
		@issue.thumb_up = ""
		@issue.datadetail_id = ""
		@issue.save
		redirect_to issuelist_index_path(id: @issue.id)
	end

	def edit
		@issue = DataIssue.where(id: params[:id])[0]
	end

	def update
		@issue = DataIssue.where(id: params[:id])[0]
		if @issue.nil?
			return
		end
		if !(params[:title].nil? || params[:title].empty?)
			@issue.title = params[:title]
		end
		if !(params[:post].nil? || params[:post].empty?)
			@issue.post = params[:post]
		end
		if !(params[:trunk_id].nil? || params[:trunk_id].empty?)
			@issue.trunk_id = params[:trunk_id]
		end
		if !(params[:tag].nil? || params[:tag].empty?)
			@issue.tag = params[:tag]
		end
		@issue.updated_at = Time.now
		@issue.save
		redirect_to issuelist_index_path(id: @issue.id)
	end

	def all
		@issues = DataIssue.where(trunk_id: -1,is_candidate: false).order(:created_at)
	end

	def candidate
		@issues = DataIssue.where(is_candidate: true)
	end

	def thumb_up
		post_id = current_user.id
		@issue = DataIssue.where(id: params[:id])[0]
		if @issue.thumb_up.nil?
			@issue.thumb_up = ""
		end
		if @issue.thumb_up.empty?
			@issue.thumb_up = @issue.thumb_up + post_id.to_s
		else
			@issue.thumb_up = @issue.thumb_up + "," + post_id.to_s
		end
		@issue.save
		redirect_to issuelist_candidate_path
	end

	def upgrade
		@issue = DataIssue.where(id: params[:id])[0]
		@issue.is_candidate = false
		@issue.save
		redirect_to issuelist_index_path(id: @issue.id)
	end
end

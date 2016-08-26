class IssuelistController < ApplicationController

	def index


		@tags = params[:id]
		@issues = DataIssue.where(is_candidate: false).order(:created_at)
		@me = @issues.where(id: @tags)[0]
		@pos_order = params[:pos_order]
		@neg_order = params[:neg_order]
		@pos_show = params[:pos_show]
		@neg_show = params[:neg_show]
		if @me ==nil
			return
		end
		if @pos_order.nil? || @pos_order.empty?
			@pos_order = "thumb"
		end
		if @neg_order.nil? || @neg_order.empty?
			@neg_order = "thumb"
		end
		if @pos_show.nil? || @pos_show.empty?
			@pos_show = "table"
		end
		if @neg_show.nil? || @neg_show.empty?
			@neg_show = "table"
		end
		detail_strings = @me.datadetail_id.split(',')
		@details = DataDetail.where(id: detail_strings,is_report: false)
		@AllLike = LikeList.where(detail_id: detail_strings)
		#@likeList = LikeList.where(post_id: current_user)
		@likeList = @AllLike.where(post_id: current_user)
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
		if @pos_order == "time"
			@support = @details.where(is_support: true).order(:created_at).reverse
		else
			@support = @details.where(is_support: true)
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
		end
		if @neg_order == "time"
			@disSupport = @details.where(is_support: false).order(:created_at).reverse
		else
			@disSupport = @details.where(is_support: false)
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
		@positive_page = params[:positive_page] 
		@negative_page = params[:negative_page]
		if(@positive_page.nil? || @positive_page.empty?)
			@positive_page = 0 
		end
		if(@negative_page.nil? || @negative_page.empty?)
			@negative_page = 0
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
				@notifyList.last_read = Time.now.in_time_zone('Taipei')
				@notifyList.save
			end
		end
		@users=User.where(id: user)
		@persons=DataPerson.where(id: person)
	end

	def add
		if !can_view(1)
			flash[:alert] = "權限不足"
			redirect_to "/"
		end
	end

	def new
		if !can_view(1)
			flash[:alert] = "權限不足"
			redirect_to "/"
			return
		end
		title = params[:title]
		post = params[:post]
		trunk_id = params[:trunk_id]
		tag = params[:tag]
		
		if !trunk_id.empty? 
			father = DataIssue.where(title: trunk_id)[0]
		end
		if father.nil?
			flash[:alert] = "無此父議題" 
			redirect_to(:back) 
			return
		end 
		@issue = DataIssue.create(created_at: Time.now.in_time_zone('Taipei'),updated_at: Time.now.in_time_zone('Taipei'))
		@issue.title = title
		@issue.post = post
		if trunk_id.nil? || trunk_id.empty?
			@issue.trunk_id = -1;
		else
			@issue.trunk_id = father.id
		end
		@issue.tag = tag
		@issue.is_candidate = true
		@issue.popularity = 0
		@issue.thumb_up = ""
		@issue.datadetail_id = ""
		@issue.save
		redirect_to issuelist_candidate_path
	end

	def edit
		if !can_editor_issue(1,params[:id])
			flash[:alert] = "權限不足"
			redirect_to "/"
		end
		@issue = DataIssue.where(id: params[:id])[0]
		@father = DataIssue.where(id: @issue.trunk_id)[0]
	end

	def update
		if !can_editor_issue(1,params[:id])
			flash[:alert] = "權限不足"
			redirect_to "/"
		end
		@issue = DataIssue.where(id: params[:id])[0]
		if !params[:trunk_id].empty? 
			father = DataIssue.where(title: params[:trunk_id])[0]
		end
		if father.nil?
			flash[:alert] = "無此父議題" 
			redirect_to(:back) 
			return
		end 
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
		@issue.updated_at = Time.now.in_time_zone('Taipei')
		@issue.save
		redirect_to issuelist_index_path(id: @issue.id)
	end

	def all
		@issues = DataIssue.where(trunk_id: -1,is_candidate: false).order(:created_at)
	end

	def candidate
		if !can_view(0)
			flash[:alert] = "權限不足"
			redirect_to "/"
		end
		@issueList = DataIssue.all
		@issues = @issueList.where(is_candidate: true).order(:thumb_up).reverse
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
		if !can_view(1)
			flash[:alert] = "權限不足"
			redirect_to "/"
		end
		@issue = DataIssue.where(id: params[:id])[0]
		@issue.is_candidate = false
		@issue.save
		redirect_to issuelist_index_path(id: @issue.id)
	end

	def toggle(attribute)
		self[attribute] = !send("#{attribute}?")
		self
	end
end

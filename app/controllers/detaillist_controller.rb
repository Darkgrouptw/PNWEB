class DetaillistController < ApplicationController
	def index
		@tags = params[:id]
		#find the data will be used in page
		@me = DataDetail.where(id: @tags)[0]
		if @me.nil?
			return
		end
		@issue = DataIssue.where(id: @me.issue_id)[0]
		@person = DataPerson.where(id: @me.people_id)[0]

		comment_ids = @me.comment_id.split(',')

		@comments = DataComment.where(id: comment_ids).order(:created_at).reverse
		user_ids = []
		@comments.each do |item|
			user_ids.push(item.post_id)
		end
		user_ids.push(@me.post_id)
		@users = User.where(id: user_ids)
		@user = @users.where(id: @me.post_id)[0]
		likelist_id = []
		likelist_ids = @me.like_list_id.split(',')
	end

	def add
		@issue = DataIssue.where(id: params[:id])[0]
	end

	def new 
		content = params[:content]
		people_id = params[:people_id]
		issue_id = params[:issue_id]
		title_at_that_time = params[:title_at_that_time]
		is_support = params[:is_support]
		is_direct = params[:is_direct]
		news_media = params[:news_media]
		report_at = params[:report_at]
		link = params[:link]
		post_id = current_user.id
		@detail = DataDetail.create(
			created_at: Time.now,
			updated_at: Time.now,
			backup_id: "",
			count: 0,
			like_list_id: "",
			comment_id: "",
			is_report: false
			)
		@detail.content = content
		@person = DataPerson.where(name: people_id)[0]
		if @person.nil?
			@detail.people_id = -1
		else
			@detail.people_id = @person.id
		end
		@detail.issue_id = issue_id
		@detail.title_at_that_time = title_at_that_time
		if is_support
			@detail.is_support = true
		else
			@detail.is_support =false
		end
		if is_direct
			@detail.is_direct = true
		else
			@detail.is_direct =false
		end
		@detail.news_media = news_media
		@detail.report_at = report_at
		@detail.link = link
		@detail.post_id = post_id
		
		@issue = DataIssue.where(id: @detail.issue_id)[0]
		@issue.datadetail_id = @issue.datadetail_id + "," + @detail.id.to_s
		@detail.save
		@issue.save
		redirect_to detaillist_index_path(id: @detail.id)
	end

	def edit
		@detail = DataDetail.where(id: params[:id])[0]
		@person = DataPerson.where(id: @detail.post_id)[0]
	end

	def update
		content = params[:content]
		people_id = params[:people_id]
		issue_id = params[:issue_id]
		title_at_that_time = params[:title_at_that_time]
		is_support = params[:is_support]
		is_direct = params[:is_direct]
		news_media = params[:news_media]
		report_at = params[:report_at]
		link = params[:link]
		@detail = DataDetail.where(id: params[:id])[0]
		if !(content.nil? || content.empty?)
			@detail.content = content
		end
		@person = DataPerson.where(name: people_id)[0]
		if @person.nil?
			@detail.people_id = -1
		else
			@detail.people_id = @person.id
		end
		if !(issue_id.nil? || issue_id.empty?)
			@detail.issue_id = issue_id
		end
		if !(title_at_that_time.nil? || title_at_that_time.empty?)
			@detail.title_at_that_time = title_at_that_time
		end
		if is_support
			@detail.is_support = true
		else
			@detail.is_support =false
		end
		if is_direct
			@detail.is_direct = true
		else
			@detail.is_direct =false
		end
		if !(news_media.nil? || news_media.empty?)
			@detail.news_media = news_media
		end
		if !(report_at.nil? || report_at.empty?)
			@detail.report_at = report_at
		end
		if !(link.nil? || link.empty?)
			@detail.link = link
		end
		@detail.save
		redirect_to detaillist_index_path(id: @detail.id)
	end

	def like
		@detail = DataDetail.where(id: params[:id])[0]
		post_id = current_user.id
		path = params[:path]
		path = path.sub('!','?').sub('|','&')
		@likelist = LikeList.create(created_at: Time.now,updated_at: Time.now)
		@likelist.detail_id = @detail.id
		@likelist.post_id = post_id
		@detail.like_list_id = @detail.like_list_id.to_s + "," +@likelist.id.to_s
		@detail.save
		@likelist.save
		#notify
		@notifyList = NotifyList.where(user_id: post_id,issue_id: @detail.issue_id)
		if @notifyList.length > 0
			#already notify
		else
			@notify = NotifyList.create(created_at: Time.now,updated_at: Time.now)
			@notify.user_id = post_id
			@notify.issue_id = @detail.issue_id
			@notify.last_read = Time.now
			@notify.newest_detail = Time.now
			@notify.save
		end
		redirect_to path
	end

	def dislike
		@detail = DataDetail.where(id: params[:id])[0]
		post_id = current_user.id
		path = params[:path]
		path = path.sub('!','?').sub('|','&')
		@likelist = LikeList.where(detail_id: @detail.id,post_id: post_id)[0]
		if @detail.like_list_id.include?("," + @likelist.id.to_s)
			@detail.like_list_id = @detail.like_list_id.sub("," + @likelist.id.to_s,"")
		else
			@detail.like_list_id = @detail.like_list_id.sub(@likelist.id.to_s,"")
		end
		@likelist.destroy
		@detail.save

		#notify
		@notifyList = NotifyList.where(user_id: post_id,issue_id: @detail.issue_id)
		if @notifyList.length > 0
			@issue =  DataIssue.where(id: @detail.issue_id)[0]
			@likelist = LikeList.where(post_id: post_id)
			stillNotify = false
			datadetail_id = @issue.datadetail_id.split(',')
			@likelist.each do |item|
				if datadetail_id.include?(item.detail_id.to_s)
					stillNotify = true
				end
			end
			if stillNotify
				# donothing
			else
				# cancle notify
				@notifyList.each do |item|
					item.destroy
				end
			end
		else
			#nothing to do ,Instead there is something wrong if code in here is been excute
		end
		redirect_to path

	end

	def comment_new
		@detail = DataDetail.where(id: params[:detail_id])[0]
		post_id = current_user.id
		content =   params[:content]
		@comment = DataComment.create(
			created_at: Time.now,
			updated_at: Time.now,
			)
		@comment.post_id = post_id
		@comment.content = content
		@detail.comment_id = @detail.comment_id + "," + @comment.id.to_s
		@comment.save
		@detail.save
		path = detaillist_index_path(id: @detail.id)
		redirect_to path
	end
end

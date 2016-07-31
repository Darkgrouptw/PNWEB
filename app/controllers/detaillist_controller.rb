class DetaillistController < ApplicationController
	def index
		tags = params[:id]
		#find the data will be used in page
		@me = DataDetail.where(id: tags)[0]
		if @me.nil?
			return
		end
		@issue = DataIssue.where(id: @me.issue_id)[0]
		@user = User.where(id: @me.post_id)[0]
		@person = DataPerson.where(id: @me.people_id)[0]
		comment_id = []
		comment_ids = @me.comment_id.split(',')
		comment_ids.each do |item|
			comment_id.push()
		end
		@comments = DataComment.where(id: comment_id).order(:created_at).reverse
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
		post_id = params[:post_id]
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
	end

	def update
	end
end

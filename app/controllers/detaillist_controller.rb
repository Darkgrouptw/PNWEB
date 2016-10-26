class DetaillistController < ApplicationController
	def index
		@tags = params[:id]
		#find the data will be used in page
		@me = DataDetail.where(id: @tags,is_report: false)[0]
		if @me.nil?
			return
		end
		@report = nil
		if !current_user.nil?
			@report = ReportDetail.where(detail_id: @tags,people_id: current_user.id)[0]
		end
		@issue = DataIssue.where(id: @me.issue_id)[0]
		@person = DataPerson.where(id: @me.people_id)[0]
		@media = DataMedium.where(name: @me.news_media)[0]
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
		@likeList = LikeList.where(detail_id: @me.id)
	end

	def add
		if !can_add_detail()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
		end
		@issue = DataIssue.where(id: params[:id])[0]
	end

	def new
		if !can_add_detail()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
		end
		#get parmater
		content = params[:content]
		people_id = params[:people_id]
		issue_id = params[:issue_id]
		title_at_that_time = params[:title_at_that_time]
		is_support = params[:is_support]
		is_direct = params[:is_direct]
		#-------------------wait for media database
		news_media = params[:news_media]
		report_at = params[:report_at]
		link = params[:link]
		backup_type = params[:backup_type]
		@issue = DataIssue.where(id: issue_id)[0]
		@person = DataPerson.where(name: people_id)[0]
		#-------------------wait for media database
		@media = DataMedium.where(name: news_media)[0]
		if @issue.nil?
			#add new people
			flash[:alert] = "沒有此議題！！"
			redirect_to issuelist_all_path
		else

			if @person.nil?
				@person = createPerson(people_id)
			end
			#-------------------wait for media database
			if @media.nil?
				@media = createMedia(news_media)
			end
			post_id = current_user.id
			@detail = DataDetail.create(
				created_at: Time.now.in_time_zone('Taipei'),
				updated_at: Time.now.in_time_zone('Taipei'),
				backup_id: "",
				count: 0,
				like_list_id: "",
				comment_id: "",
				is_report: false,
				content: content,
				people_id: @person.id,
				people_name: @person.name,
				issue_id: issue_id,
				title_at_that_time: title_at_that_time,
				#-------------------wait for media database
				news_media: @media.name,
				report_at: report_at,
				link: link,
				post_id: post_id,
				is_support: is_support,
				is_direct: is_direct,
				#-------------------wait for detail database
				backup_type: ""
				)
			if is_support
				@detail.is_support = true
			else
				@detail.is_support = false
			end
			if is_direct
				@detail.is_direct = true
			else
				@detail.is_direct = false
			end
			@detail.backup_id = @issue.id.to_s + "_" + @detail.id.to_s
			@issue.datadetail_id = addIDToString(@issue.datadetail_id,@detail.id)
			@person.datadetail_id = addIDToString(@person.datadetail_id,@detail.id)
			@media.datadetail_id = addIDToString(@media.datadetail_id,@detail.id)
			current_user.datadetail_id = addIDToString(current_user.datadetail_id,@detail.id)
			#notify
			@notifyList =  NotifyList.where(issue_id: @issue.id)
			if !@notifyList.nil?
				@notifyList.each do |item|
					item.newest_detail = Time.now.in_time_zone('Taipei')
					item.save
				end
			end

			@detail.save
			@issue.save
			@person.save
			@media.save
			current_user.save
			
			puts "---------" + backup_type.to_s + "-------------------"
			#backup picture
			#check if it is need or can be backup
			if backup_type == 0.to_s
				check = checkBackUP(@detail.link)
				if !check.nil?
					require "uri"
					require "net/http"
					require "open-uri"
					require 'json'
					rest_api = "http://api.page2images.com/restfullink"
					url = @detail.link
					p2i_device = "6"
					p2i_screen="1024x768"
					p2i_size="1024x0"
					p2i_fullpage="1"
					p2i_key="8e549b1ac48187d3"
					rest_key="42b2fe10a13f636c"
					p2i_wait="0"
					parameters = {
					"p2i_url" => url,
					"p2i_key" => rest_key,
					"p2i_device" => p2i_device,
					"p2i_size" => p2i_size,
					"p2i_screen" => p2i_screen,
					"p2i_fullpage" => p2i_fullpage,
					"p2i_wait" => p2i_wait
					}
					#open a thread
					process = true
					Thread.new do
						maxWatingTime = 60
						start_time = Time.new
		
						while(process && (Time.new - start_time) < maxWatingTime)
							resp = Net::HTTP.post_form(URI(rest_api),parameters)
							resp_text = resp.body
							result = JSON.parse(resp.body)
							puts "-------------------------------"
							puts resp.body
							puts "-------------------------------"
							if result["status"] == "finished"
								open('public/pageBackUp/' + @detail.issue_id.to_s + "_" + @detail.id.to_s + '.png','wb') do |file|
									file << open(result["image_url"]).read
								end
								process = false
							elsif result["status"] = "processong"
								sleep(5)
							end
						end
					end
					@detail.backup_type = "png"
					@detail.save
				else
					@detail.backup_id = check
				end
			elsif backup_type == 1.to_s || backup_type == 2.to_s
				#save file
				puts "---------------------------------------------------------"
				#puts params[:fileToUpload].path
				open('public/pageBackUp/' + @detail.issue_id.to_s + "_" + @detail.id.to_s + "." + getFileTypeFromPath(params[:fileToUpload].path),'wb') do |file|
					file << params[:fileToUpload].read
				end
				@detail.backup_type = getFileTypeFromPath(params[:fileToUpload].path)
				@detail.save
			elsif backup_type == 3.to_s
				#do nothing
				@detail.backup_type = "none"
				@detail.save
			end
			
			redirect_to detaillist_index_path(id: @detail.id)
		end
	end

	def checkBackUP(path)
		result = nil
		detail = DataDetail.where(link: path,is_report: false)[0]
		if !detail.nil?
			result = detail.backup_id
		end
		return result
	end

	def edit
		if !can_editor_detail()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
		end
		@detail = DataDetail.where(id: params[:id],is_report: false)[0]
		@person = DataPerson.where(id: @detail.post_id)[0]
	end

	def update
		if !can_editor_detail()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
		end
		content = params[:content]
		people_id = params[:people_id]
		issue_id = params[:issue_id]
		title_at_that_time = params[:title_at_that_time]
		is_support = params[:is_support]
		is_direct = params[:is_direct]
		news_media = params[:news_media]
		report_at = params[:report_at]
		link = params[:link]
		@detail = DataDetail.where(id: params[:id],is_report: false)[0]
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
		if !can_like()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
		end
		@detail = DataDetail.where(id: params[:id],is_report: false)[0]
		post_id = current_user.id
		path = params[:path]
		path = path.gsub('!','?').gsub('|','&')
		@likelist = LikeList.create(created_at: Time.now.in_time_zone('Taipei'),updated_at: Time.now.in_time_zone('Taipei'))
		@likelist.detail_id = @detail.id
		@likelist.post_id = post_id
		@detail.like_list_id = @detail.like_list_id.to_s + "," +@likelist.id.to_s
		
		#notify
		@notifyList = NotifyList.where(user_id: post_id,issue_id: @detail.issue_id)
		if @notifyList.length > 0
			#already notify
		else
			@notify = NotifyList.create(created_at: Time.now.in_time_zone('Taipei'),updated_at: Time.now.in_time_zone('Taipei'),newest_detail: Time.now.in_time_zone('Taipei'),last_read: Time.now.in_time_zone('Taipei'))
			@notify.user_id = post_id
			@notify.issue_id = @detail.issue_id
			@notify.save
		end
		@detail.save
		@likelist.save
		redirect_to(:back)
	end

	def dislike
		if !can_like()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
		end
		@detail = DataDetail.where(id: params[:id],is_report: false)[0]
		post_id = current_user.id
		path = params[:path]
		path = path.gsub('!','?').gsub('|','&')
		@likelist = LikeList.where(detail_id: @detail.id,post_id: post_id)[0]
		if @detail.like_list_id.include?("," + @likelist.id.to_s)
			@detail.like_list_id = @detail.like_list_id.gsub("," + @likelist.id.to_s,"")
		else
			@detail.like_list_id = @detail.like_list_id.gsub(@likelist.id.to_s,"")
		end
		@likelist.destroy
		

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
		@detail.save
		redirect_to (:back)

	end
	def groupeDislike
		if !can_like()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
		end
		detail_ids = params[:detail_ids]
		detail_ids = detail_ids.split(',')
		details = DataDetail.where(id: detail_ids)
		issue = DataIssue.where(id: details[0].issue_id)[0]
		likeList = LikeList.where(detail_id: detail_ids,post_id: current_user.id)
		notify = NotifyList.where(user_id: current_user.id,issue_id: issue.id)[0]
		details.each do |detail|
			#like
			if params[detail.id.to_s]
				like = likeList.where(detail_id: detail.id)[0]
				detail.like_list_id = removeIDFromString(detail.like_list_id,like.id.to_s)
				like.destroy
			end
		end
		#notify
		stillNotify = false
		likelist = LikeList.where(post_id: current_user)
		likelist.each do |item|
			if stringHasID(issue.datadetail_id,item.detail_id.to_s)
				stillNotify = true
			end
		end
		if stillNotify
		else
			notify.destroy
		end
		redirect_to(:back)
	end
	def comment_new
		if !can_add_comment()
			flash[:alert] = "權限不足"
			redirect_to(:back)
		end
		@detail = DataDetail.where(id: params[:detail_id],is_report: false)[0]
		post_id = current_user.id
		content =   params[:content]
		@comment = DataComment.create(
			created_at: Time.now.in_time_zone('Taipei'),
			updated_at: Time.now.in_time_zone('Taipei'),
			)
		@comment.post_id = post_id
		@comment.content = content
		@detail.comment_id = @detail.comment_id + "," + @comment.id.to_s
		@comment.save
		@detail.save
		path = detaillist_index_path(id: @detail.id)
		redirect_to path
	end

	def createPerson(name)
		search_result = DataPerson.where(name: name)[0]
		if !search_result.nil?
			#此名人已存在
			return search_result
		end
		person = DataPerson.create(created_at: Time.now.in_time_zone('Taipei'),updated_at: Time.now.in_time_zone('Taipei'))
		person.name = name
		#-------------------wait for person database
		person.datadetail_id = ""
		person.pic_link = nil
		person.description = "none description"
		person.save
		return person
	end
	def createMedia(name)
		search_result = DataMedium.where(name: name)[0]
		if !search_result.nil?
			#the media already exit
			return search_result
		end
		media = DataMedium.create(created_at: Time.now.in_time_zone('Taipei'),updated_at: Time.now.in_time_zone('Taipei'))
		media.name = name;
		media.description = "none description"
		media.datadetail_id=""
		media.valid_name = ""
		media.save
		return media
	end
end

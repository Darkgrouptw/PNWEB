class MainController < ApplicationController
	
	def index
		# 刪除 email 得 Session
		clearEmailSession

		@issues=DataIssue.where(trunk_id: -1,is_candidate: false).order(:created_at).reverse.first(10)
		@details=DataDetail.all.order(:count).reverse.first(10)
		person = []
		@details.each do |detail|
			person.push([detail.people_id])
		end
		@persons=DataPerson.where(id: person)
	end

	def notify
		@notifyList = NotifyList.all
		user_ids = []
		issue_ids = []
		@notifyList.each do |item|
			user_ids.push(item.post_id)
			issue_ids.push(item.issue_id)
		end
		@users = User.where(id: user_ids)
		@issues = DataIssue.where(id: issue_ids)
		#send email to each user
		@users.each do |user|
			title = user.nickname + " 你好，正反網頁有新的通知"
			hasContent = false
			content = ""
			issue_ids = []
			notifys = @notifyList.where(user_id: user.id)
			notifys.each do |notify|
				issue = @issues.where(id: notify.issue_id)
				#check is need to notify
				if notify.newest_detail > notify.last_read
					#notify!
					hasContent = true
					content = content + issue.title + ": " + issuelist_index_path(id: issue.id) +  "\n"
				end
			end
			if hasContent
				#email
				Email.send(user.email,title,content)
			end
		end
	end

	def peopleName
		name = params[:name]
		@content = ""
		@persons = DataPerson.where("name like ?", name + "%").first(5)
		@persons.each do |person|
			if @content.length <= 0
				@content = @content + person.name
			else
				@content = @content  + "," + person.name
			end
		end
		puts @content
	end

	def issueName
		name = params[:name]
		@content = ""
		@issues = DataIssue.where("title like ?", name + "%").first(5)
		@issues.each do |issue|
			if @content.length <= 0
				@content = @content + issue.title
			else
				@content = @content  + "," + issue.title
			end
		end
		puts @content
	end
end

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

	 # 
    # 開一個 EmailThread 來執行定時寄信的功能 (設定時間為禮拜六 凌晨4點)
    #
    def open_thread
        if $EmailThread == nil
            # 把 EmailDate 轉成台灣
            @EmailDate = Time.now.in_time_zone('Taipei')
            puts "================================="
            puts "時間的 Thread 已經開啟了"
            puts "================================="
            $EmailThread = Thread.new do
                while true do
                    sleep(1.minutes)
                    puts "=========================================="
                    puts "prepare To Send Email "
                    puts "=========================================="
                    #if @EmailDate.friday? and @EmailDate.hour == 18
                    #@EmailDate.tuesday? and @EmailDate.hour == 4
                    if @EmailDate.tuesday? and @EmailDate.hour == 4
                        puts "=========================================="
                        puts "Start To Send Email "
                        puts "=========================================="
                        notify
                        sleep(22.hours)
                    end
                end
            end
            redirect_to "/", :notice => "成功開啟定時寄信的功能囉 ！！"
        else
            redirect_to "/", :notice => "已經開啟過囉 ！！"
        end
    end

	def notify
		@notifyList = NotifyList.all
		user_ids = []
		issue_ids = []
		@notifyList.each do |item|
			user_ids.push(item.user_id)
			issue_ids.push(item.issue_id)
		end
		@users = User.where(id: user_ids)
		@issues = DataIssue.where(id: issue_ids,is_candidate: false)
		#send email to each user
		@users.each do |user|
			title = user.nickname + " 你好，正反網頁有新的通知"
			hasContent = false
			content = ""
			issue_ids = []
			notifys = @notifyList.where(user_id: user.id)
			notifys.each do |notify|
				issue = @issues.where(id: notify.issue_id)[0]
				#check issue is exit
				if issue.nil?
				else
					#check is need to notify
					if notify.newest_detail > notify.last_read
						#notify!
						hasContent = true
						content = content + issue.title + ": " + issuelist_index_path(id: issue.id) +  "\n"
					end
				end
			end
			if hasContent
				#email
				send_notify_email(user.email,title,content)
			end
		end

		redirect_to(:back)
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

	private
    #寄信
    def send_notify_email(email,title,content)
        require 'net/smtp'

        tempSMTP = Net::SMTP.new 'smtp.gmail.com', 587
        tempSMTP.enable_starttls
        tempSMTP.start("gmail.com", "npwebntust@gmail.com", "NTUSTCSIE2016", :login) do |smtp|
            smtp.open_message_stream('npwebntust@gmail.com', [email]) do |f|
                f.puts "Content-type: text/plain; charset=UTF-8"
                f.puts "From: 正反網頁<npwebntust@gmail.com>"
                f.puts "To: " + email
                f.puts 'Subject: ' + title
                f.puts
                f.puts content
            end
        end
    end
end

class MainController < ApplicationController
	
    def findNearHotIssue(issue_list)
    end

    def findNearHotIssueTree(issueTree_list)
    end

    def findNearHotPeople(people_list)
    end

    def findInfluencePeople(people_list)
    end

    def findInfluenceMedia()
    end

    def findBalanceMedia()
    end

    def writeDataFromFile
        #   從檔案讀資料進來
        require 'json'
        path = ""
        file = File.read(path)
        data_hash = JSON.parse(file)
    end

	def index
		# 刪除 email 得 Session
		clearEmailSession
		@issues=DataIssue.where(trunk_id: -1,is_candidate: false).order(:created_at).reverse.first(10)
		@details=DataDetail.where(is_report: false).order(:count).reverse.first(10)
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
    
    
    
    #
    # 編輯樹
    #
    def treeindex
        #
        #   AAA
        #   / \
        # BBB CCC
        
        #@treeData = [Tree.new("AAA")]
    end
    
    def treecanvas
    end
    
    def treejson
        #
        #     AAA
        #    / | \
        # BBB CCC DDD
        # 限制：不能有兩顆以上的 Tree
        @jsonFile = "{'item': {
            'id': 0, 'name': 'AAA', 'color': '#DB7093', 'parent': [
                {'id': 1, 'name': 'BBB', 'color': '#4169E1', 'parent': [
                    {'id': 4, 'name': 'EEE'},
                    {'id': 5, 'name': 'EEE'},
                    {'id': 6, 'name': 'EEE'},
                    {'id': 7, 'name': 'EEE'},
                    {'id': 8, 'name': 'EEE'},
                    {'id': 9, 'name': 'EEE'},
                    {'id': 10, 'name': 'EEE'}
                ]},
                {'id': 2, 'name': 'CCC'},
                {'id': 3, 'name': 'DDD'}
            ]}
            }"
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
		@issues = DataIssue.where(is_candidate: false).where("title like ?", name + "%").first(5)
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

#
# 自定義一個 Tree 的 Data Structure
#
class Tree
    def initialize(title)
        @root = Node.new(title)
        @parent = Array.new()
    end
    
    def SetParent(name)
    end
    
    def GetParent()
        return @parent
    end
    
    def GetRoot()
        return @root
    end
    
    #def searchNodeName(name)
    #end
    
    def AddChildFromName(forName, childName)
    end
end
#
#
#
class Node
    def initialize(name)
        @name = name
        @childlist = Array.new(0)
    end
    
    def name()
        return @name
    end
    
    def AddChild(name)
        @childlist.push(Node.new(@name))
    end
end
    
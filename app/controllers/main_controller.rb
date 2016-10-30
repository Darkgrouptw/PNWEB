class MainController < ApplicationController
	
    def findNearHotIssue(issue_list)
        likelist = LikeList.where( created_at: (Time.now.in_time_zone('Taipei') - 1.day)..Time.now.in_time_zone('Taipei'))
        counter = []
        recorder = [];
        issue_list.each do |issue|
            counter.push(0);
            recorder.push(issue.id);
        end
        likelist.each do |like|
            for i in 0..counter.length - 2
                issue = issue_list.where(id: recorder[i])[0]
                if stringHasID(issue.datadetail_id,like.detail_id)
                    counter[i] = counter[i] + 1
                end
            end
        end
        for i in 0..counter.length - 2
            for j in 0..counter.length - i - 2
                if counter[j] < counter[j + 1]
                    temp = counter[j]
                    counter[j] = counter[j + 1]
                    counter[j + 1] = temp
                    temp = recorder[j]
                    recorder[j] = recorder[j + 1]
                    recorder[j + 1] = temp
                end
            end
        end
        result = []
        recorder.first(10).each do |record|
            result.push(issue_list.where(id: record)[0])
        end
        return result
    end

    def findNearHotIssueTree()
    end

    def findNearHotPeople(people_list)
        likelist = LikeList.where(created_at: (Time.now.in_time_zone('Taipei') - 7.day)..Time.now.in_time_zone('Taipei'))
        counter = []
        recorder = [];
        people_list.each do |people|
            counter.push(0);
            recorder.push(people.id);
        end
        likelist.each do |like|
            for i in 0..counter.length - 1
                people = people_list.where(id: recorder[i])[0]
                if stringHasID(people.datadetail_id,like.detail_id)
                    counter[i] = counter[i] + 1
                end
            end
        end
        for i in 0..counter.length - 2
            for j in 0..counter.length - i - 2
                if counter[j] < counter[j + 1]
                    temp = counter[j]
                    counter[j] = counter[j + 1]
                    counter[j + 1] = temp
                    temp = recorder[j]
                    recorder[j] = recorder[j + 1]
                    recorder[j + 1] = temp
                end
            end
        end
        #return people_list.where(id: recorder.first(10))
        result = []
        recorder.first(10).each do |record|
            result.push(people_list.where(id: record)[0])
        end
        return result
    end

    def findInfluencePeople(people_list)
        counter = []
        recorder = []
        people_list.each do |people|
            counter.push(getStringIDLength(people.datadetail_id))
            recorder.push(people.id)
        end
        for i in 0..counter.length - 2
            for j in 0..counter.length - i - 2
                if counter[j] < counter[j + 1]
                    temp = counter[j]
                    counter[j] = counter[j + 1]
                    counter[j + 1] = temp
                    temp = recorder[j]
                    recorder[j] = recorder[j + 1]
                    recorder[j + 1] = temp
                end
            end
        end
        return people_list.where(id: recorder.first(10))
    end

    def findInfluenceMedia(media_list)
        counter = []
        recorder = []
        media_list.each do |media|
            counter.push(getStringIDLength(media.datadetail_id))
            recorder.push(media.id)
        end
        for i in 0..counter.length - 2
            for j in 0..counter.length - i - 2
                if counter[j] < counter[j + 1]
                    temp = counter[j]
                    counter[j] = counter[j + 1]
                    counter[j + 1] = temp
                    temp = recorder[j]
                    recorder[j] = recorder[j + 1]
                    recorder[j + 1] = temp
                end
            end
        end
        return media_list.where(id: recorder.first(10))
    end

    def findBalanceMedia(media_list)
        counter = []
        recorder = []
        detail_str = []
        detail_all = DataDetail.all
        media_list.each do |media|
            detail_str = media.datadetail_id.split(',')
            details = detail_all.where(id: detail_str).order(:issue_id)
            sum = 0
            issue_ids = []
            details.each do |detail|
                if !issue_ids.include? detail.issue_id
                    issue_ids.push(detail.issue_id)
                end
            end
            issue_ids.each do |issue_id|
                issue_details = details.where(issue_id: issue_id)
                num_neg = 0
                num_pos = 0
                issue_details.each do |detail|
                    if detail.is_support
                        num_pos = num_pos + 1
                    else
                        num_neg = num_neg + 1
                    end
                end
                sum = sum + [num_neg,num_pos].min
            end

            counter.push(sum)
            recorder.push(media.id)
        end


        for i in 0..counter.length - 2
            for j in 0..counter.length - i - 2
                if counter[j] < counter[j + 1]
                    temp = counter[j]
                    counter[j] = counter[j + 1]
                    counter[j + 1] = temp
                    temp = recorder[j]
                    recorder[j] = recorder[j + 1]
                    recorder[j + 1] = temp
                end
            end
        end
        return media_list.where(id: recorder.first(10))

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
		#@issues=DataIssue.where(trunk_id: -1,is_candidate: false).order(:created_at).reverse.first(10)
        @issues = DataIssue.where(is_candidate: false)
        @people = DataPerson.all
        @media = DataMedium.all
        @NearHotIssue = findNearHotIssue(@issues)
        @NearHotPeople = findNearHotPeople(@people)
        @InfluenceMedia = findInfluenceMedia(@media)
        @influencePeople = findInfluencePeople(@people)
        @BalanceMedia = findBalanceMedia(@media)
        @NearHotIssueTree = findNearHotIssueTree()
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
        @items = TreeInfo.order(updated_at: :desc).first(10)
        @issue_info = []
        @nicknames = []
        @up = []
        @hasThumpAlready = []
        @times = []
        
        @items.each do |item|
            temp = DataIssue.where(id: item.id)[0]
            @issue_info.push(temp)
            
            
            temp = User.where(id: item.people_id)[0]
            if temp == nil
                @nicknames.push("")
            else
                @nicknames.push(temp.nickname)
            end
            
            # 按讚的個數
            @up.push(getStringIDLength(item.like_list_id))
            if current_user != nil
                @hasThumpAlready.push(stringHasID(item.like_list_id, current_user.id))
            end
            
            @times.push(item.updated_at.strftime("%Y/%m/%d"))
        end
    end
    
    def treecanvas
    end
    
    def tree_thumb_up
        paramsStr = ""
        if params[:page] != nil
            paramsStr = "?page=" + params[:page]
        end
        
        if current_user != nil
            info = TreeInfo.where(id: params[:id])[0]
            if !stringHasID(info.like_list_id, current_user.id)
                info.like_list_id += current_user.id + ","
            end
        end
        
        redirect_to "/TreeIndex" + paramsStr
    end
    
    def treejson
        item = TreeInfo.where(id: params[:id])[0]
        @jsonFile = item.info
        #
        #     AAA
        #    / | \
        # BBB CCC DDD
        # 限制：不能有兩顆以上的 Tree
        #@jsonFile = "{'item': {
        #    'name': 'AAA', 'color': '#DB7093', 'parent': [
        #        {'name': 'BBB', 'color': '#4169E1', 'parent': [
        #            {'name': 'EEE', 'color': '#6495ED', 'parent': []},
        #            {'name': 'E', 'color': '#6495ED', 'parent': []}
        #        ]},
        #        {'name': 'CCC', 'color': '#6495ED', 'parent': []},
        #        {'name': 'DDD', 'color': '#6495ED', 'parent': []}
        #    ]}
        #}"
    end
    
    def tree_check
        name = params[:name]
        @content = ""
        @issue = DataIssue.where(is_candidate: false,title: name)[0]
        if @issue.nil?
            @content = "false"
        else
            @content = "true"
        end
        puts @content
    end
    
    
    
    #
    # 其他功能
    #
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

    def mediaName
        name = params[:name]
        @content = ""
        @medias = DataMedium.where("name like ?", name + "%").first(5)
        @medias.each do |media|
            #@content = addIDToString(@content,media.name)
            if @content.length <= 0
                @content = @content + media.name
            else
                @content = @content  + "," + media.name
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
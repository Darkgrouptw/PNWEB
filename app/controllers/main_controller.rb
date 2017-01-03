class MainController < ApplicationController
	def findNearHotIssue(issue_list)
		likelist = LikeList.where( created_at: (Time.now.in_time_zone('Taipei') - 7.day)..Time.now.in_time_zone('Taipei')).where(ip: "Taiwan")
		counter = []
		recorder = [];
		issue_list.each do |issue|
			counter.push(0);
			recorder.push(issue.id);
		end
		likelist.each do |like|
			for i in 0..counter.length - 1
				issue = issue_list.where(id: recorder[i])[0]
				if stringHasID(issue.datadetail_id,like.detail_id)
					counter[i] = counter[i] + 1
				end
			end
		end
		for i in 0..counter.length - 1
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
		#@issues = @issues.sort_by{|item| item.datadetail_id.length}.reverse
	end
	def findNearHotIssueTree(treeInfo)
		counter = []
		recorder = [];
		treeInfo.each do |item|
			counter.push(getStringIDLength(item.like_list_id));
			recorder.push(item.id);
		end
		for i in 0..counter.length - 1
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
			result.push(treeInfo.where(id: record)[0])
		end
		return result
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
		for i in 0..counter.length - 1
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
		for i in 0..counter.length - 1
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
			result.push(people_list.where(id: record)[0])
		end
		return result
	end

	def findInfluenceMedia(media_list)
		counter = []
		recorder = []
		media_list.each do |media|
			counter.push(getStringIDLength(media.datadetail_id))
			recorder.push(media.id)
		end
		for i in 0..counter.length - 1
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
			result.push(media_list.where(id: record)[0])
		end
		return result
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


		for i in 0..counter.length - 1
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
			result.push(media_list.where(id: record)[0])
		end
		return result
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
		@treeInfo = TreeInfo.all
		@NearHotIssue = findNearHotIssue(@issues)
		@NearHotPeople = findNearHotPeople(@people)
		@InfluenceMedia = findInfluenceMedia(@media)
		@influencePeople = findInfluencePeople(@people)
		@BalanceMedia = findBalanceMedia(@media)
		@NearHotIssueTree = findNearHotIssueTree(@treeInfo)
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
        if params[:search] != nil &&  params[:search] != ""             # 判斷他是否有這個參數
            @searchParams = params[:search]
            @addLink = "&search=" + @searchParams
            @issueList = DataIssue.where(title: params[:search])
            
            if @issueList.length != 0
                @TreeInfoList = TreeInfo.where(issue_id: @issueList[0])
            else
                # 找不到東西，所以用 id 是 -1 來找
                @TreeInfoList = TreeInfo.where(id: -1)
            end
        else
            @searchParams = ""
            @addLink = "";
            @TreeInfoList = TreeInfo.all
        end
        
		@OrderBy = params[:OrderBy]
		if @OrderBy == 0.to_s
			@items = @TreeInfoList.where(created_at: (Time.now.in_time_zone('Taipei') - 7.day)..Time.now.in_time_zone('Taipei'))
			@items = findNearHotIssueTree(@items)
		elsif @OrderBy == 1.to_s
            @addLink = @addLink + "&OrderBy=1"
			@items = @TreeInfoList.order(created_at: :desc).first(10)
		elsif @OrderBy == 2.to_s
            @addLink = @addLink + "&OrderBy=2"
			@items = @TreeInfoList.order(created_at: :desc)
			@items = findNearHotIssueTree(@items)
		else
			@items = @TreeInfoList.where(created_at: (Time.now.in_time_zone('Taipei') - 7.day)..Time.now.in_time_zone('Taipei'))
			@items = findNearHotIssueTree(@items)
		end
		
		@issue_info = []
		@nicknames = []
		@up = []
		@hasThumpAlready = []
        @createTimeArray = []
		@updateTimeArray = []
		
		@items.each do |item|
			temp = DataIssue.where(id: item.issue_id)[0]
			@issue_info.push(temp)
			
			
			temp = User.where(id: item.people_id)[0]
			if temp == nil
				@nicknames.push("")
			else
				@nicknames.push(temp.nickname)
			end
			
			# 按贊的個數
			@up.push(getStringIDLength(item.like_list_id))
			if current_user != nil
				@hasThumpAlready.push(stringHasID(item.like_list_id, current_user.id))
			end
			
			@createTimeArray.push(item.created_at.strftime("%Y/%m/%d"))
			@updateTimeArray.push(item.updated_at.strftime("%Y/%m/%d"))
		end
	end
	
	def treecanvas
		@id = -1
		if params[:id] != nil
			@id = TreeInfo.where(id: params[:id])
		end
	end
	
	def tree_thumb_up
		paramsStr = ""
		if params[:page] != nil
			paramsStr = "?page=" + params[:page]
		end
		
		if current_user != nil
			info = TreeInfo.where(id: params[:id])[0]
			if !stringHasID(info.like_list_id, current_user.id)
				info.like_list_id += current_user.id.to_s + ","
				info.save
			end
		end
		
        if params[:OrderBy] != nil
            addLink = "?OrderBy=" + params[:OrderBy]
        end
        
		redirect_to "/TreeIndex" + paramsStr + addLink
	end
	
	def treejson
		item = TreeInfo.where(id: params[:id])[0]
		
		require 'cgi'
		require 'nokogiri'
		@jsonFile = CGI.unescapeHTML(item.info)
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
	
	def root_add
		title = DataIssue.where(title: params[:name])[0]
		if title == nil
			flash[:warning] = "沒有這個議題!!"
			redirect_to "/TreeIndex"
			return
		end
		titleID = title.id
		
		item = TreeInfo.new
		item.issue_id = titleID
		item.people_id = current_user.id
		item.info = "{'item': {
                    'id': '" + titleID.to_s + "',
					'name': '" + params[:name] + "', 'color': '#3DA5D9', 'parent': []
					}}"
		item.like_list_id = ""
		item.save
		redirect_to "/TreeIndex"
	end
	
    #
    # 把 Node 存進 Db 裡面，並作一些處理
    #
	def tree_save_all_node
        # 把東西存起來
		node = TreeInfo.where(id: params[:id])[0]
		node.info = params[:TreeInfo].to_s.gsub("\"","\'")
		node.save
        
        # 要先把以前的東西刪掉
        TreeLink.where(treeinfo_id: params[:id]).destroy_all
        
        # 要去 Trace 所有的樹，處理下游議題
        require 'json'
        @parseItem = JSON.parse(params[:TreeInfo])
        @parseItem = [@parseItem['item']]
        
        while @parseItem.length != 0
            childArray = @parseItem[0]['parent']
            childArray.each do |childItem|
                item = TreeLink.new
                item.issue_id = @parseItem[0]['id']
                item.treeinfo_id = params[:id]
                item.children_id = childItem['id']
                item.save
                @parseItem.push(childItem)
            end
            
            # 把第一個丟掉
            @parseItem.shift
        end
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
		@details = DataDetail.where(issue_id: issue_ids,is_report: false)
		#send email to each user
		@users.each do |user|
			notifyNumber = 0
			title = user.nickname + " 你好，正反網頁有新的通知"
			hasContent = false
			content = ""
			issue_ids = []
			notifys = @notifyList.where(user_id: user.id)
			notifys.each do |notify|
				issue = @issues.where(id: notify.issue_id)[0]
				notifyNumber = notifyNumber + @details.where(issue_id: issue.id).where('created_at >= ?',notify.last_read).length
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
			if hasContent && notifyNumber >= 20
				#email
				send_notify_email(user.email,title,content)
			end
		end

		redirect_to(:back)
	end

	def peopleName
		name = params[:name]
		@content = ""
		@persons = DataPerson.where("name like ?","%" +  name + "%").first(5)
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
		@issues = DataIssue.where(is_candidate: false).where("title like ?", "%" + name + "%").first(5)
		@issues.each do |issue|
			if @content.length <= 0
				@content = @content + issue.title
			else
				@content = @content  + "," + issue.title
			end
		end
		puts @content
	end
    
    def issueID
        title = params[:title]
        @content = ""
        if title == nil || title == ""
            return
        end
		@issues = DataIssue.where(title: title)
        if @issues.length != 0
            @content = @issues[0].id
        end
    end

	def mediaName
		name = params[:name]
		@content = ""
		@medias = DataMedium.where("name like ?","%" +  name + "%").first(5)
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
	def ipTest
		@result = ipInfo()
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
module Common
	
	def getOtherParameter(object,paraName)
		if object.nil? || object.other.nil?
			return nil
		end
		other = object.other
		require 'json'
		if !valid_json?(other)
			other = "{}"
		end
		otherJson = JSON.parse(other)
    	return otherJson[paraName]
	end

	def setOtherParameter(object,paraName,value)
		other = object.other
		if other.nil? || other.empty?
			other = "{}"
		elsif !valid_json?(other)
			other = "{}"
		end
		require 'json'
		otherJson = JSON.parse(other)
		otherJson[paraName] = value
		object.other = otherJson.to_json
		return
	end
	def valid_json?(json)
	  begin
	    JSON.parse(json)
	    return true
	  rescue JSON::ParserError => e
	    return false
	  end
	end
	def testYou(kasim,john)
		return kasim + john
	end

	def checkDisable()
		if current_user.nil?
			return
		end
		disableLevel = getOtherParameter(current_user,"suspended")
		if disableLevel.to_s != "0"
			disableDays = getOtherParameter(current_user,"days")
			if disableDays.nil? || disableDays.empty? || disableDays == "-1"
			else
				lastSuspended = Time.parse(getOtherParameter(current_user,"lastSuspended"))
				nowTime = Time.now
				if (nowTime - disableDays.to_i.days ) > lastSuspended
					setOtherParameter(current_user,"suspended","0")
					setOtherParameter(current_user,"days","-1")
					current_user.save
				end
			end
		end
		return
	end

	def ipInfo()
		require 'net/http'
		@ip = params[:ip]
		@ip = current_user.ip
		#@ip = "140.118.175.92"
		begin
			url = URI.parse('http://ip-api.com/json/'+@ip)
			req = Net::HTTP::Get.new(url.to_s)
			res = Net::HTTP.start(url.host, url.port) {|http|
			  http.request(req)
			}
			@result = JSON.parse(res.body)
			return res.body;
		rescue Exception
			return "";
		else
			return "";
		end
		#@result = @result['country']
	end
	
	def mergePeople(p1,p2)
		people1 = DataPerson.where(name: p1)[0]
		people2 = DataPerson.where(name: p2)[0]
		if people1.nil? || people2.nil?
			return
		end
		people1.valid_name = addIDStringToString(people1.valid_name,people2.valid_name)
		people1.datadetail_id = addIDStringToString(people1.datadetail_id,people2.datadetail_id)
		people2.valid_name = ""
		people2.datadetail_id = ""
		people_ids = []
		people_ids.push(people1.id)
		people_ids.push(people2.id)
		DataDetail.where(people_id: people_ids).each do |detail|
			detail.people_id = people1.id
			detail.save
		end
		people1.save
		people2.save
	end

	def mergeMedia(m1,m2)
		media1 = DataMedium.where(name: m1)[0]
		media2 = DataMedium.where(name: m2)[0]
		if media1.nil? || media2.nil?
			return
		end
		media1.valid_name = addIDStringToString(media1.valid_name,media2.valid_name)
		media1.datadetail_id = addIDStringToString(media1.datadetail_id,media2.datadetail_id)
		media2.valid_name = ""
		media2.datadetail_id =""
		media_names = []
		media_names.push(media1.name)
		media_names.push(media2.name)
		DataDetail.where(news_media: media_names).each do |detail|
			detail.news_media = media1.name
			detail.save
		end
		media1.save
		media2.save
	end

	def isTaiwan()
		require 'net/http'
		if current_user.nil?
			return false
		end
		@ip = current_user.ip
		#@ip = "140.118.175.92"
		begin
			url = URI.parse('http://ip-api.com/json/'+@ip)
			req = Net::HTTP::Get.new(url.to_s)
			res = Net::HTTP.start(url.host, url.port) {|http|
			  http.request(req)
			}
			data = JSON.parse(res.body)
			if data["status"] == "success"
				if data["country"] == "Taiwan"
					return true
				else
					return false
				end
			else
				return false
			end
		rescue Exception
			return "";
		else
			return "";
		end
	end
	def treejsonInfo(id)
		treeInfo = TreeInfo.where(id: id.to_s)[0]
		if treeInfo.nil?
			return ""
		else
			string_info = treeInfo.info
			if string_info.nil?
				return ""
			else
				return string_info.gsub("\'","\"")
			end
		end
	end

	def removeIDFromString(str,id)
		result = str
		if result.nil? || result.empty?
			return ""
		end
		temp = result.split(",")
		result = ""
		temp.each do |subS|
			if subS == id.to_s
				subS = ""
			end
			result = addIDToString(result,subS)
		end
		#if result.include?(id.to_s)
		#	if result.include?("," + id.to_s)
		#		result = result.sub("," + id.to_s,"")
		#	else
		#		result = result.sub(id.to_s,"")
		#	end
		#end
		return result
	end

	def addIDToString(str,id)
		result = str
		if result.nil?
			result = ""
		end
		if id.nil? || id.to_s.empty?
			return result
		end
		if result.empty?
			result = id.to_s
		else
			result = result + "," + id.to_s
		end
		return result
	end

	def addIDStringToString(str1,str2)
		result = str1
		if str2.nil? || str2.empty?
			return str1
		end
		if str1.nil? || str2.empty?
			return str2
		end
		str2.split(',').each do |item|
			if result.empty?
				result = item.to_s
			else
				result = result + "," + item.to_s
			end
		end
		return result
	end

	def stringHasID(str,id)
		if str.nil?
			return false
		end
		if str.empty?
			return false
		end
		if str.split(',').include?(id.to_s)
			return true
		end
		return false
	end
	def getStringIDLength(str)
		if str.nil? || str.empty?
			return 0
		end
		count = 0
		str.split(',').each do |subS|
			if subS.nil? || subS.empty?
			else
				count = count + 1
			end
		end
		return count
	end
	def FileIsExit(fileName)
		return File.exist?(Rails.root + "public/" + fileName)
	end

	def getFileTypeFromPath(path)
		string_spilt = path.split(".")
		return string_spilt[string_spilt.length - 1]
	end

	def isLocal(ip)
		if ip == "false"
			return false
		elsif ip == "true"
			return true
		end
				
	end
	def String_like(str,search)
		if str.nil? || str.empty?
			return false
		end
		if search.nil? || search.empty?
			return true
		end
		if str.include? search
		   return true
		end
		return false
	end

	def parseTree(treeS) 
    	require 'json'
    	data = JSON.parse(treeS)
    	return data["item"]
	end

	def deleteIssue(id)
		issue = DataIssue.where(id: id)[0]
		if issue.nil?
			return
		end
		issue.datadetail_id.split(",").each do |item|
			deleteDetail(item)
		end
		
		TreeInfo.all.each do |tree|
			require 'json'
			if searchTree(parseTree(treejsonInfo(tree.id)),issue.title)
				tree.destroy
			else
			end
		end
		issue.destroy
	end
	def searchTree(tree,name)
        if(tree["name"].to_s == name)
        	return true
        end
    	tree["parent"].each do |sub_tree|
        	if searchTree(sub_tree,name)
        		return true
			end
    	end
    	return false
	end
	def deleteDetail(id)
		@me = DataDetail.where(id: params[:id])[0]
		if @me.nil?
			return
		end
		@people = DataPerson.where(id: @me.people_id)[0]
		@issue = DataIssue.where(id: @me.issue_id)[0]

		@media = DataMedium.where(name: @me.news_media)[0]

		if @issue.nil?
			@likelist = LikeList.where(detail_id: -1)	
		else
			@likelist = LikeList.where(detail_id: @issue.datadetail_id.split(","))	
		end
		users = []
		@likelist.where(detail_id: @me.id).each do |like|
			users.push(like.post_id)
		end
		@users = User.where(id: users)
		@user = User.where(id: @me.post_id)[0]
		@comments = DataComment.where(detail_id: @me.id)
		@reports = ReportDetail.where(detail_id: @me.id)
		@notifyList = NotifyList.where(issue_id: @me.issue_id)

		#disable connection
		#people
		if !@people.nil?
			@people.datadetail_id = removeIDFromString(@people.datadetail_id,@me.id)
		end
		#issue
		if !@issue.nil?
			@issue.datadetail_id = removeIDFromString(@issue.datadetail_id,@me.id)
		end
		#media
		if !@media.nil?
			@media.datadetail_id = removeIDFromString(@media.datadetail_id,@me.id)
		end
		#user
		if @user.nil?
		else
			@user.datadetail_id = removeIDFromString(@user.datadetail_id,@me.id)
		end
		

		#destroy data
		#destroy notifyList
		@users.each do |user|
			if @likelist.where(post_id: user.id).where.not(detail_id: @me.id).length <= 0
				@notifyList.where(user_id: user.id)[0].destroy
			end
		end
        
		#destroy like
		@likelist.each do |like|
			if like.detail_id == @me.id
				like.destroy
			end
		end
        
		#destroy comment
		@comments.each do |comment|
			if comment.detail_id == @me.id
				comment.destroy
			end
		end
        
		#destroy report
		@reports.each do |report|
			if report.detail_id == @me.id
				report.destroy
			end
		end
		if !@people.nil?
			@people.save
		end
		if !@issue.nil?
			@issue.save
		end
		if !@media.nil?
			@media.save
		end
		if !@user.nil?
			@user.save
		end
		if !@me.nil?
			@me.destroy
		end
		
		return
	end

	def backUpALlDetail()
		DataDetail.all.each do |detail|
			if detail.backup_type == "png"
				if true
					require "uri"
					require "net/http"
					require "open-uri"
					require 'json'
					rest_api = "http://api.page2images.com/restfullink"
					url = detail.link
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
								open('public/pageBackUp/' + detail.issue_id.to_s + "_" + detail.id.to_s + '.png','wb') do |file|
									file << open(result["image_url"]).read
								end
								process = false
							elsif result["status"] = "processong"
								sleep(5)
							end
						end
					end
				else
				end
			end
		end
	end
end
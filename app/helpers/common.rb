module Common
	
	def testYou(kasim,john)
		return kasim + john
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
end
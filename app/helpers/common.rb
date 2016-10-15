module Common
    
    def testYou(kasim,john)
        return kasim + john
    end

    def removeIDFromString(str,id)
        result = str
        if result.nil? || result.empty?
            return ""
        end
        if result.include?(id.to_s)
            if result.include?("," + id.to_s)
                result = result.sub("," + id.to_s,"")
            else
                result = result.sub(id.to_s,"")
            end
        end
        return result
    end

    def addIDToString(str,id)
        result = str
        if result.nil?
            result = ""
        end
        if result.empty?
            result = id.to_s
        else
            result = result + "," + id.to_s
        end
        return result
    end
end
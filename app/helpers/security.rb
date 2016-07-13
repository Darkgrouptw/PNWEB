module Security
    def encrypt_password(str)
        byebug
        require 'openssl'
        require 'Base64'
        
        return Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha512"), "NTUST-PNWEB", str)).strip()
    end
    
    def is_uuid(str)
        # 判斷 a-f or 0-9
        if str == ""
            return false
        end
        
        if str[/[a-f0-9]+/] == str && str.length == 64
            return true
        end
        return false
    end
    
    def is_email(str)
        if str == "" || str.include?("|") || str.include?("!") || str.include?("=") || str.include?("'") || str.include?("\"") || !str.include?("@")
            return false
        end
        return true
    end
    
    # 產生 uuid 的 Function 
    def make_uuid()
        # 長度為 64
        return SecureRandom.hex(32)
    end
end
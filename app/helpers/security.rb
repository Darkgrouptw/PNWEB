module Security
    
    # 產生 uuid 的 Function 
    def make_uuid()
        return SecureRandom.hex(32)
    end
end
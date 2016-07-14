module Userinfo
    #
    # 如果 session 有 UserID and UserToken 兩個要正確，才能拿到 current_user
    #
    def current_user
        if session[:UserID] == nil || session[:UserToken] == nil
            return nil
        end
        
        
        userlist  = User.where(:id => session[:UserID], :token => session[:UserToken])
        if userlist.count == 0
            session.delete(:UserID)
            session.delete(:UserToken)
            @userinfo = nil
            return nil
        end
        
        if @userinfo != nil
            return @userinfo 
        end
        
        @userinfo = userlist[0]
        return @userinfo
    end
    
    #
    # 確認 Token 是否過期，如果過期，直接將 token & id 刪除
    #
    def verifyToken
        # 有沒有 User 資訓
        if session[:UserID] == nil || session[:UserToken] == nil
            return
        end
        
        userlist = User.where(:id => session[:UserID], :token => session[:UserToken])
        if userlist.count == 0
            return
        end
        @userinfo = userlist[0]
        
        @userinfo.ip = request.remote_ip
        if @userinfo.last_login_in - DateTime.now > 2.weeks
            session.delete(:UserID)
            session.delete(:UserToken)
            @userinfo.Token = ""
        end

        @userinfo.save
        
        if @userinfo.last_login_in - DateTime.now > 2.weeks
            @userinfo = nil
        end
    end
    
    #
    # 刪除認證郵件的 session
    #
    def clearEmailSession
        if session[:email] != nil
            session.delete(:email)
        end
        
        if session[:token] != nil
            session.delete(:token)
        end
    end
end
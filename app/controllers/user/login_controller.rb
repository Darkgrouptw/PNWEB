class User::LoginController < ApplicationController
    def login
    end
    
    def logout
        if session[:UserID] != nil
            session.delete(:UserID)
        end
        if session[:UserToken] != nil
            session.delete(:UserToken)
        end
        redirect_to "/"
        flash[:notice] = "登出成功！！"
    end
end

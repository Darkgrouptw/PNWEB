class User::LoginController < ApplicationController
    #
    # 登入介面
    #
    def login
        if current_user
            redirect_to "/"
            flash[:notice] = "已經登入囉！！"
            return
        end
    end
    
    #
    # 登出介面
    #
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
    
    #
    # 驗證登入是否正確！！
    #
    def verify
        if !is_email(params[:email])
            redirect_to :back
            flash[:alert] = "信箱或密碼有錯誤，請重新填寫！！"
            return
        end
        
        if params[:password] == ""
            redirect_to :back
            flash[:alert] = "信箱或密碼有錯誤，請重新填寫！！"
            return
        end
        
        if params[:password][/[a-zA-Z0-9]+/] != params[:password]
            redirect_to :back
            flash[:alert] = "有不合法的字，請重新填寫"
            return
        end
        
        userList = User.where(:email => params[:email], :password => encrypt_password(params[:password]))
        if userList.count == 0
            redirect_to :back
            flash[:alert] = "沒有該使用者帳號或密碼錯誤！！"
            return
        end
        
        session[:UserID] = userList[0].id
        session[:UserToken] = make_uuid
        userList[0].token = session[:UserToken]
        userList[0].last_login_in = DateTime.now
        userList[0].save
        
        redirect_to "/"
        flash[:notice] = "登入成功！！"
        return
    end
end

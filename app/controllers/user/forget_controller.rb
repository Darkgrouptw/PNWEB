class User::ForgetController < ApplicationController
    
    #
    # 重設密碼的 form
    #
    def send_email_form
    end
    
    #
    # 確認是否可以重設信箱，並寄一封信到你的信箱做確認
    #
    def send_email
        # 如果是空的
        if params[:email] == nil
            redirect_to :back
            flash[:warning] = "無效參數"
            return
        end
        
        users = User.where(email: params[:email])
        
        # 代表沒有這個信箱
        if users.length == 0
            flash[:warning] = "沒有這個 email 喔！！"
            redirect_to :back
            return
        end
        
        @email = users[0].email
        send_forget_email_email(users[0].token ,users[0].email)
    end
    
    #
    # 要確定東西能不能
    #
    def verify
        if params[:email] == nil || params[:token] == nil
            flash[:alert] = "錯誤參數"
            redirect_to "/"
            return
        end
        
        users = User.where(email: params[:email])
        if users.length == 0
            flash[:alert] = "沒有這個使用者喔！！"
            redirect_to "/"
            return
        end
        
        if users.token != params[:token]
            flash[:alert] = "資料不符合"
            redirect_to "/"
            return
        end
        
        session[:email] = params[:email]
        session[:token] = params[:token]
        redirect_to "/ForgetForm"
    end
    
    #
    # 填寫表單
    #
    def form
        @token = session[:token]
        @email = session[:email]
        
        if @token == nil || @email == nil
            redirect_to "/"
            flash[:alert] = "流程錯誤！！"
            return
        end
    end
    
    #
    # 最後更改密碼的地方
    #
    def reset_password
        if !is_uuid(params[:token]) || ! is_email(params[:email])
            redirect_to :back
            flash[:alert] = "請勿擅自修改資料喔！！"
            return
        end
        
        # 接下來要判斷參數對不對，有沒有沒勾的或沒值的
        require 'rest-client'
        require 'rubygems'
        require 'json'
        response = RestClient.post "https://www.google.com/recaptcha/api/siteverify",
                :secret => "6LeX2SQTAAAAAKbIPMl-1aYU63KgVEQRWPs6o7Bv",
                :response => params["g-recaptcha-response"],
                :remoteip => request.remote_ip
        reCaptcha = JSON.parse(response.to_s)
        
        if !reCaptcha["success"]
            redirect_to :back
            flash[:alert] = "機器人驗證碼有錯誤！！"
            return
        end
        
        # 驗證輸入的東西對不對
        if params[:password] != params[:password_confirm]
            redirect_to :back
            flash[:alert] = "兩個密碼不太一樣！！"
            return
        end
        
        
        if params[:password][/[a-zA-Z0-9]+/] != params[:password]
            redirect_to :back
            flash[:alert] = "有不合法的字，請重新填寫"
            return
        end
        
        if params[:password].length < 6 
            redirect_to :back
            flash[:alert] = "密碼小於 6 個字！！"
            return
        end 
        
        # 刪除 session
        session.delete(:token)
        session.delete(:email)
        
        redirect_to "/"
        flash[:notice] = "重設成功！！"
    end

    
    private
	#寄信
	def send_forget_email_email(passID, email)
        require 'net/smtp'

        tempSMTP = Net::SMTP.new 'smtp.gmail.com', 587
        tempSMTP.enable_starttls
        tempSMTP.start("gmail.com", "npwebntust@gmail.com", "NTUSTCSIE2016", :login) do |smtp|
            smtp.open_message_stream('npwebntust@gmail.com', [email]) do |f|
                f.puts "Content-type: text/plain; charset=UTF-8"
                f.puts "From: 正反網頁<npwebntust@gmail.com>"
                f.puts "To: " + email
                f.puts 'Subject: 正反網頁 - 重設密碼信'
                f.puts
                f.puts "親愛的 " + email + "你好："
                f.puts
                f.puts "\t請點擊下面網址，及繼續接下來的流程\nhttps://npweb.herokuapp.com/ForgetPassword/VerifyForgetLink?token=" + passID + "&email=" + email
            end
        end
    end
end

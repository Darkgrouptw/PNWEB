class User::RegisterController < ApplicationController
    def index
    end
    
    #
    # Send Email 去認證信箱
    #
    def sendEmail
        if !is_email(params[:email])
            redirect_to register_email_path
            flash[:alert] = "請輸入正確的信箱！！"
            return
        end
        
        # 確定是否已經驗證過了
        userList = User.where(:email => params[:email])
        if userList.count != 0
            redirect_to register_email_path
            flash[:alert] = "此帳號已經註冊過囉！！"
            return
        end
            
        
        emailList = VerifyList.where(:email => params[:email])
        
        # 如果沒有找到的話，代表要新增一筆資料，然後產生 uuid
        # 如果有的話，判斷時間是不是在固定時間內，如果是，就重新產生 uuid 傳過去，沒有就請他等待
        if emailList.count == 0
            uuid = make_uuid
            verifyUser = VerifyList.create(verifylist_params)
            verifyUser.uuid = uuid
            verifyUser.save
            
            send_verfiy_email(uuid, params[:email])
            
            redirect_to wait_for_verify_path + "?Email=" + params[:email]
            return
        else
            # 算時間差距
            diference = DateTime.current().to_f - emailList[0].updated_at.to_f
            if diference > 1.minutes
                uuid = make_uuid
                emailList[0].uuid = uuid
                emailList[0].save
                
                send_verfiy_email(uuid, params[:email])
                redirect_to wait_for_verify_path + "?Email=" + params[:email]
                return
            else
                redirect_to(:back)
                flash[:alert] = "請於 1 分鐘之後，再重試"
                return
            end
        end
    end
    
    #
    # 等待認證的介面
    #
    def wait
        @email = params[:Email]
    end
    
    #
    # 要認證的網址
    #
    def verify
        # 判斷長度
        if !is_uuid(params[:token])
            redirect_to "/"
            flash[:alert] = "請確定 Token 長度是不是正確的！！"
            return
        end
        
        # 判斷是不是正確的 email
        if !is_email(params[:email])
            redirect_to "/"
            flash[:alert] = "請確定是不是正確的 Email !!"
            return
        end
        
        # 判斷有沒有這筆資料
        item = VerifyList.where(email: params[:email])
        if item.count == 0
            redirect_to "/"
            flash[:alert] = "此郵件沒有聲請過認證信喔！！"
            return
        end
        
        # 判斷 token 正不正確
        if item[0].uuid != params[:token]
            redirect_to "/"
            flash[:alert] = "Token 有問題，請聯繫最高管理者幫忙處理！！"
            return
        end
        
        session[:token] = params[:token]
        session[:email] = params[:email]
        redirect_to register_form_path
    end
    
    def form
        @token = session[:token]
        @email = session[:email]
        
        if @token == nil || @email == nil
            redirect_to "/"
            flash[:alert] = "流程錯誤！！"
            return
        end
        
        if !is_uuid(@token) || !is_email(@email)
            redirect_to "/"
            flash[:alert] = "傳送 Form 的參數有問題，請聯絡最高管理者幫忙處理！！"
            return
        end
    end
    
    def success
        if !is_uuid(params[:token]) || ! is_email(params[:email])
            redirect_to :back
            flash[:alert] = "請勿擅自修改資料喔！！"
            return
        end
        
        # 判斷有沒有這筆資料
        item = VerifyList.where(email: params[:email])
        if item.count == 0
            redirect_to :back
            flash[:alert] = "請勿擅自修改資料喔！！"
            return
        end
        
        # 判斷 token 正不正確
        if item[0].uuid != params[:token]
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
        
        userList = User.where(:email => params[:email])
        if userList.count != 0
            redirect_to "/"
            flash[:alert] = "此帳號已經註冊過囉！！"
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
        
        if params[:sex] == nil || !(params[:sex] == "male" || params[:sex] == "female" || params[:sex] == "other")
            redirect_to :back
            flash[:alert] = "請選擇性別！！"
            return
        end
        
        if params[:password].length < 6 
            redirect_to :back
            flash[:alert] = "密碼小於 6 個字！！"
            return
        end
        
        if params[:nickname] == nil
            redirect_to :back
            flash[:alert] = "暱稱沒有填寫！！"
            return
        end
        
        if params[:date] == nil
            redirect_to :back
            flash[:alert] = "時間沒有填寫！！"
            return
        end
        
        countryArray = ["台灣", "大陸", "新加坡", "馬來西亞", "泰國", "越南","巴西", "阿根廷", "美國", "英國"]
        if params[:liveplace].to_i <= 0 || params[:liveplace].to_i > countryArray.count
            redirect_to :back
            flash[:alert] = "沒有這個國家代碼喔！！"
            return
        end
        
        newUser = User.new
        newUser.email = params[:email]
        newUser.password = encrypt_password(params[:password])
        
        # 性別的判斷
        case params[:sex]
            when "male"
                newUser.sex = 0
            when "female"
                newUser.sex = 1
            else
                newUser.sex = 2
        end
        newUser.birth = params[:date].gsub("-", "/")
        newUser.nickname = params[:nickname]
        newUser.level = 0
        newUser.ip = request.remote_ip
        newUser.last_login_in = DateTime.now
        newUser.liveplace = countryArray[params[:liveplace].to_i - 1]
        newUser.token = make_uuid
        
        newUser.save
        
        #Save 完之後才有 ID
        session[:UserID] = newUser.id
        session[:UserToken] = newUser.token
        
        item[0].destroy
        
        # 刪除 session
        session.delete(:token)
        session.delete(:email)
        
        
        redirect_to "/"
        flash[:notice] = "註冊成功！！"
    end
    
    
    private
    #寄信
    def send_verfiy_email(uuid, email)
        require 'net/smtp'

        tempSMTP = Net::SMTP.new 'smtp.gmail.com', 587
        tempSMTP.enable_starttls
        tempSMTP.start("gmail.com", "npwebntust@gmail.com", "NTUSTCSIE2016", :login) do |smtp|
            smtp.open_message_stream('npwebntust@gmail.com', [email]) do |f|
                f.puts "Content-type: text/plain; charset=UTF-8"
                f.puts "From: 正反網頁<npwebntust@gmail.com>"
                f.puts "To: " + email
                f.puts 'Subject: 正反網頁的認證信'
                f.puts
                f.puts "親愛的 " + email + "你好："
                f.puts
                f.puts "\t這是你的認證網址，請點擊下面網址，及繼續接下來的流程\nhttps://npweb.herokuapp.com/VerifyEmail?token=" + uuid + "&email=" + email
            end
        end
    end
    
    def verifylist_params
        params.permit(:email)
    end
end
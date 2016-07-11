class User::RegisterController < ApplicationController
    include Security
    
    def index
    end
    
    def sendEmail
        if params[:email] == "" || params[:email].include?("|") || params[:email].include?("!") || params[:email].include?("=") || params[:email].include?("'") || params[:email].include?("\"") || !params[:email].include?("@")
            redirect_to register_email_path
            flash[:warning] = "請輸入正確的信箱！！"
            return
        end
        
        emailList = VerifyList.where(:email => params[:email])
        
        # 如果沒有找到的話，代表要新增一筆資料，然後產生 uuid
        # 如果有的話，判斷時間是不是在固定時間內，如果是，就重新產生 uuid 傳過去，沒有就請他等待
        #byebug
        require "rest-client"
        if emailList.count == 0
            uuid = make_uuid
            verifyUser = VerifyList.create(verifylist_params)
            verifyUser.uuid = uuid
            verifyUser.save
            
            send_email(uuid, params[:email])
            
            redirect_to wait_for_verify_path + "?Email=" + params[:email]
            return
        else
            # 算時間差距
            diference = DateTime.current().to_f - emailList[0].updated_at.to_f
            if diference > 1.hour
                uuid = make_uuid
                emailList[0].uuid = uuid
                emailList[0].save
                
                send_email(uuid, params[:email])
                redirect_to wait_for_verify_path + "?Email=" + params[:email]
                return
            else
                redirect_to(:back)
                flash[:warning] = "請於 1個小時之後，再重試"
                return
            end
            #byebug
        end
        #byebug
    end
    
    def wait
        @email = params[:Email]
    end
    
    private
    
    # 寄信
    def send_email(uuid, email)
        RestClient.post "https://api:key-ddabee7356c4bbecc5c1846d6994a2ec"\
            "@api.mailgun.net/v3/sandbox2bbf267493614a8b843884423bc7a480.mailgun.org/messages",
            :from => "正反網頁 <postmaster@sandbox2bbf267493614a8b843884423bc7a480.mailgun.org>",
            :to => "<" + email + ">",
            :subject => "正反網頁 - 信箱驗證信",
            :text => "親愛的 " + params[:email] + "你好：\n\t這是你的認證網址，請點擊下面網址，及繼續接下來的流程\nhttps://npweb.herokuapp.com/VerifyEmail?token="+uuid+"&email="+email
    end
    
    def verifylist_params
        params.permit(:email)
    end
end
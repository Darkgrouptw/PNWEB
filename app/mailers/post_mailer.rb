class PostMailer < ApplicationMailer
    default :from => 'npwebntust@gmail.com'
    
    # send a signup email to the user, pass in the user object that   contains the user's email address
    def send_verify_email(uuid, email)
        mail(   :to         => email,
                :subject    => "正反網頁 驗證信",
                :text       => "親愛的 " + params[:email] + "你好：\n\t這是你的認證網址，請點擊下面網址，及繼續接下來的流程\nhttps://npweb.herokuapp.com/VerifyEmail?token="+uuid+"&email="+email )
    end
end

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

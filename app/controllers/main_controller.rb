class MainController < ApplicationController
	def index
        puts "------------------------------"
        puts "Main"
        puts "------------------------------"
        
		@issues=DataIssue.where(trunk_id: -1).order(:created_at).reverse.first(10)
        @details=DataDetail.where(is_report: false).order(:count).reverse.first(10)
        person = []
        @details.each do |detail|
            person.push([detail.people_id])
        end
        @persons=DataPerson.where(id: person)
        if user_signed_in?
            puts "!!!!! Has user login !!!!!"
            if current_user.email == "darkgrouptw@gmail.com" || current_user.email == "b10215014@mail.ntust.edu.tw" || current_user.email == "apple@gmail.com"
                puts "Is Admin"
                #logger.debug 
                User.where(email: current_user.email)[0].update(high_power: true)
            else
                User.where(email: current_user.email)[0].update(high_power: false)
            end
        end
        
        # 判斷 EmailThread 是不是打開來的，管理者可以關閉這個選項
        if $EmailThread == nil
            @Is_EmailThrea_nil = true
        else
            @Is_EmailThrea_nil = false
        end
    end
    
    # 
    # 管理誰可以是最高權限，誰不是最高權限
    #
    def manage_power
        if !user_signed_in?
            flash[:warning] = "你不能使用這個喔"
            redirect_to "/"
            return
        end
        if current_user.high_power
            flash[:warning] = "你不能使用這個喔"
            redirect_to "/"
            return
        end
    end
    
    # 
    # 開一個 EmailThread 來執行定時寄信的功能 (設定時間為禮拜六 凌晨4點)
    #
    def open_thread
        if $EmailThread == nil
            # 把 EmailDate 轉成台灣
            @EmailDate = Time.now.in_time_zone('Taipei')
            puts "================================="
            puts "時間的 Thread 已經開啟了"
            puts "================================="
            $EmailThread = Thread.new do
                while true do
                    sleep(10.minutes)
                    #if @EmailDate.friday? and @EmailDate.hour == 18
                    if @EmailDate.tuesday? and @EmailDate.hour == 4
                        puts "=========================================="
                        puts "Start To Send Email on " + @EmailDate.to_s
                        puts "=========================================="
                        send_email
                        sleep(22.hours)
                    end
                end
            end
            redirect_to "/", :notice => "成功開啟定時寄信的功能囉 ！！"
        else
            redirect_to "/", :notice => "已經開啟過囉 ！！"
        end
    end
    
    
    def close_thread
        if $EmailThread != nil
            puts "================================="
            puts "時間的 Thread 已經關閉了"
            puts "================================="
            $EmailThread.exit
            $EmailThread = nil
            flash[:notice] = "關閉成功"
        end
        redirect_to "/"
    end
    
    private
    def send_email
        require "rest-client"
        
        # 每個使用者都傳信過去
        tempUser = User.all
        tempuser.each do |u|
            if true
                # 這個是 測試版本
                RestClient.post "https://api:key-ddabee7356c4bbecc5c1846d6994a2ec"\
                "@api.mailgun.net/v3/sandbox2bbf267493614a8b843884423bc7a480.mailgun.org/messages",
                :from => "正反網頁 <postmaster@sandbox2bbf267493614a8b843884423bc7a480.mailgun.org>",
                :to => u.nickname + " <" + u.email + ">",
                :subject => "Hello Test " + u.nickname,
                :text => "Hello Email 測試"
            else
                # 等驗證完後，再把這個打開
                RestClient.post "https://api:key-ddabee7356c4bbecc5c1846d6994a2ec"\
                "@api.mailgun.net/v3/dark.npweb.com/messages",
                :from => "正反網頁 <postmaster@dark.npweb.com>",
                :to => u.nickname + " <" + u.email + ">",
                :subject => "Hello " + u.nickname,
                :text => "Hello Email 測試"
            end
        end
	end
end

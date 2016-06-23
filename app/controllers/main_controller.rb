class MainController < ApplicationController
	def index
        puts "------------------------------"
        puts "Main"
        puts "------------------------------"
        
		@issues=DataIssue.where(trunk_id: -1).order(:created_at).reverse.first(10)
        @details=DataDetail.order(:count).reverse.first(10)
        person = []
        @details.each do |detail|
            person.push([detail.people_id])
        end
        @persons=DataPerson.where(id: person)
        if user_signed_in?
            logger.debug "!!!!! Has user login !!!!!"
            if current_user.email == "darkgrouptw@gmail.com" || current_user.email == "b10215014@mail.ntust.edu.tw"
                logger.debug "Is Admin"
                #logger.debug 
                User.where(email: current_user.email)[0].update(high_power: true)
            else
                User.where(email: current_user.email)[0].update(high_power: false)
            end
        end
        
    end
    def send_email
        require "rest-client"
        if true
            # 這個是 測試版本
            RestClient.post "https://api:key-ddabee7356c4bbecc5c1846d6994a2ec"\
            "@api.mailgun.net/v3/sandbox2bbf267493614a8b843884423bc7a480.mailgun.org/messages",
            :from => "正反網頁 <postmaster@sandbox2bbf267493614a8b843884423bc7a480.mailgun.org>",
            :to => "TestEmail <darkgrouptw@gmail.com>",
            :subject => "Test test test",
            :text => "Hello Email 測試"
        else
            # 等驗證完後，再把這個打開
            RestClient.post "https://api:key-ddabee7356c4bbecc5c1846d6994a2ec"\
            "@api.mailgun.net/v3/dark.npweb.com/messages",
            :from => "正反網頁 <postmaster@dark.npweb.com>",
            :to => "Nickname <darkgrouptw@gmail.com>",
            :subject => "Test test test",
            :text => "Hello Email 測試"
        end
	end
    
    def thread
        puts "====================="
        puts "Thread => " + Thread.list.select {|thread| thread.status == "run"}.count.to_s
        puts "====================="
    end
end

class ApplicationController < ActionController::Base
    before_action :User_check
    
    include Security
    include Userinfo
    
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    
    protected
    
    def User_check
        verifyToken
        if current_user.email == "darkgrouptw@gmail.com" || current_user.email == "b10215014@mail.ntust.edu.tw"
            current_user.level = 4
            current_user.save
        end
    end
end

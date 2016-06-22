class ReportlistController < ApplicationController
    before_filter :authenticate_user!
    
    def index
        if current_user.high_power
            //123
        else
            redirect "/", flash[:warning]="必須要擁有最高權限！！"
        end
    end
end

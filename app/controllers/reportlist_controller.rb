class ReportlistController < ApplicationController
    before_filter :authenticate_user!
    
    def index
        if current_user.high_power
            @reportDetail = ReportDetail.order(:created_at)
            detail_ids = []
            @reportDetail.each do |item|
            	detail_id.push(item.detail_id)
            end
            @detail = DataDetail.where(id: detail_ids)
            issue_ids = []
            user_ids = []
            @detail.each do |item|
            	issue_ids.push(item.issue_ids)
            	user_ids.push(item.post_id)
            end
            @issue = DataIssue.where(id: issue_ids)
            @user = User.where(id: user_ids)
        else
            redirect "/", flash[:warning]="必須要擁有最高權限！！"
        end
    end
end

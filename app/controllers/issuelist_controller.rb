class IssuelistController < ApplicationController
	def index
		@tags = params[:issue_id]
		@issues=DataIssue.all.order(:created_at)
		@all_issue = true
		if @issues.where(id: @tags).length >= 1
			@me = @issues.where(id: @tags)[0]
			@strings = @me.datadetail_id.split(/,/)
			@details=DataDetail.where(id: @strings)
            @detail_supprot = @details.where(is_support: true).order(:count_like).reverse
            @detail_disSupport = @details.where(is_support: false).order(:count_dislike).reverse
            user = []
            person = []
            @details.each do |detail|
                user.push([detail.post_id])
                person.push([detail.people_id])
            end
			@users=User.where(id: user)
            @persons=DataPerson.where(id: person)
			@all_issue = false
		else
			@all_issue = true
		end
	end
    
    def new
        if current_user == nil
            flash[:alert] = "請先登入!!"
            redirect_to :back
        else
            @detail = DataDetail.new
        end
    end
    
    def create
        @detail = DataDetail.create(detail_params)
        @detail.issue_id = params[:issue_id]
        @detail.count = 0
        @detail.count_like = 0
        @detail.count_dislike = 0
        if current_user == nil
            flash[:alert] = "請先登入!!"
            redirect_to :back
        else
            @detail.post_id = current_user.id
                @detail.comment_id = ""
            if @detail.save
                @tags = params[:issue_id]
                @issue = DataIssue.where(:id => @tags)[0]
                @issue.datadetail_id = @issue.datadetail_id + @detail.id.to_s + ","
                @issue.update(issue_params)
                redirect_to issuelist_path
            else
                render :new
            end
        end
    end
    
    
    private
    
    def detail_params
        params.require(:data_detail).permit(:is_support, :content, :link, :count, :count_like, :count_dislike, :post_id, :people_id, :issue_id, :comment_id, :comment_id, :issue_id)
    end
    
    def issue_params
        params.require(:data_detail).permit(:datadetail)
    end
end

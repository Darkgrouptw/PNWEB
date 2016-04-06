class IssuelistController < ApplicationController
	def index
		@tags = params[:issue_id]
		@issues=DataIssue.all.order(:created_at)
		@all_issue = true
		if @issues.where(id: @tags).length >= 1
			@me = @issues.where(id: @tags)[0]
			@strings = @me[:datadetail_id].split(/,/)
			@details=DataDetail.where(@strings.include? :id)
			@users=User.all
			@all_issue = false
			@persons=DataPerson.all
		else
			@all_issue = true
		end
	end
    
    def new
        @detail = DataDetail.new
    end
    
    def create
        @detail = DataDetail.create(detail_params)
        @detail.issue_id = params[:issue_id]
        @detail.count = 0
        @detail.count_like = 0
        @detail.count_dislike = 0
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
    
    
    private
    
    def detail_params
        params.require(:data_detail).permit(:is_support, :content, :link, :count, :count_like, :count_dislike, :post_id, :people_id, :issue_id, :comment_id, :comment_id, :issue_id)
    end
    
    def issue_params
        params.require(:data_detail).permit(:datadetail)
    end
end

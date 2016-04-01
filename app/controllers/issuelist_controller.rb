class IssuelistController < ApplicationController
	def index
		@tags = params[:issue_id]
		@issues=DataIssue.all.order(:created_at)
		@all_issue = true
		if @issues.where(id: @tags).length >= 1
			@me = @issues.where(id: @tags)[0]
			@datadetail=DataDetail.where(issue_id: @me.id)
			@users=User.all
			@all_issue = false
		else
			@all_issue = true
		end
	end
end

class IssuelistController < ApplicationController
	def index
		@tags = params[:issue_id]
		@issues=DataIssue.all
		@persons=DataPerson.all
		@datadetail=DataIssue.all
		@users=User.all
	end
end

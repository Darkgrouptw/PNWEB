class IssuelistController < ApplicationController
	def index
		@tags = params[:issue_id]
		@contents = DataContent.all
		@issues=DataIssue.all
		@persons=DataPerson.all
		@pointers=DataPointer.all
	end
end

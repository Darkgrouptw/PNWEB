class MainController < ApplicationController
	def index
		@contents = DataContent.all
		@issues_OrderByUpdated=DataIssue.where(parent_id: -1).order(:updated_at)
		@issues=DataIssue.all
		@persons=DataPerson.all
		@pointers=DataPointer.all
	end
end

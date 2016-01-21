class PeoplelistController < ApplicationController
	def index
		@tags = params[:name]
		@contents = DataContent.all
		@issues=DataIssue.all
		@persons=DataPerson.all
		@pointers=DataPointer.all
	end
end

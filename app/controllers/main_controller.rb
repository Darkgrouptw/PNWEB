class MainController < ApplicationController
	def index
		@contents = DataContent.all
		@issues=DataIssue.all
		@persons=DataPerson.all
		@pointers=DataPointer.all
	end
end

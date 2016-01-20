class DataitemsController < ApplicationController
	before_action	:find_Operation

	private

	def find_Operation
		@operation = params[:op]

		if @operation == "Data_issue" 
			@state = 0
		elsif @operation == "Data_person"
			@state = 1
		elsif @operation == "Data_content"
			@state = 2
		elsif @operation == "Data_pointer"
			@state = 3
		else
			@state = -1
		end
	end
end

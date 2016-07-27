class PeoplelistController < ApplicationController
	def index
		@tags = params[:id]
		@me = DataPerson.all.where(name: @tags)[0]
		if @me.nil?
			return
		end
		issue_ids = []
		#find all the detail is said by the @me
		@details = DataDetail.where(people_id: @me.id)
		@details.each do |detail|
			issue_ids.push(detail.issue_id)
		end
		#find all the issue connect with details
		@issues = DataIssue.where(id: issue_ids)

	end
	def all
		@persons=DataPerson.all
	end
end

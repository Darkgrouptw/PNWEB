class PeoplelistController < ApplicationController
	def index
		@tags = params[:name]
		@person=DataPerson.where(name: @tags)
		@all_people = true
		if @person.where(name: @tags).length >= 1
			@person = @person[0]
			@details=DataDetail.where(people_id: @person.id).order(:count).reverse
			issue = []
			user = []
			@details.each do |detail|
				issue.push([detail.issue_id])
				user.push([detail.post_id])
			end
			@issues = DataIssue.where(id: issue)
			@users=User.where(id: user)
			@all_people = false
		else
			@all_people = true
			@persons=DataPerson.all
		end
	end
end

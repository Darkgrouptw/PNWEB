class PeoplelistController < ApplicationController
	def index
		@tags = params[:name]
		@person=DataPerson.where(name: @tags)
		@all_people = true
		if @person.where(name: @tags).length >= 1
			@person = @person[0]
			@details=DataDetail.where(people_id: @person.id)
			@issues=DataIssue.all
			@users=User.all
			@all_people = false
		else
			@all_people = true
			@persons=DataPerson.all
		end
		
		
	end
end

class PeoplelistController < ApplicationController
	def index
		@tags = params[:name]
		@person=DataPerson.where(name: @tags)
		@person.where(name: @tags).each do |p|
			@details=DataDetail.where(people_id: p.id)
		end
		@persons=DataPerson.all
		@issues=DataIssue.all
		@users=User.all
	end
end

class UserlistController < ApplicationController
	def index
		@tags = params[:user_id]
		@user=User.where(id: @tags)
		@all_people = true
		if @user.where(id: @tags).length >= 1
			@user = @user[0]
			@details=DataDetail.where(post_id: @user.id)
			person = []
			issue = []
			@details.each do |detail|
				person.push([detail.people_id])
				issue.push([detail.issue_id])
			end
			@issues=DataIssue.where(id: issue)
			@people = DataPerson.where(id: person)
			@all_people = false
		else
			@all_people = true
		end
	end
end

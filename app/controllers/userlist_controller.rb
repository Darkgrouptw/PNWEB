class UserlistController < ApplicationController
	def index
		@tags = params[:user_id]
		@user=User.where(id: @tags)
		@all_people = true
		if @user.where(id: @tags).length >= 1
			@user = @user[0]
			@details=DataDetail.where(post_id: @user.id)
			@issues=DataIssue.all
			@people = DataPerson.all
			@all_people = false
		else
			@all_people = true
		end
		
		
	end
end

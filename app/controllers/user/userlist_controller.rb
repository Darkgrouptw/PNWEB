class User::UserlistController < ApplicationController
	def index
		@me = User.where(id: params[:id])[0]
		@details = DataDetail.where(post_id: @me.id)
		issue_ids = []
		@details.each do |item|
			issue_ids.push(item.issue_id)
		end
		@issues = DataIssue.where(id: issue_ids,is_candidate: false)
	end

	def upgrade
		@me = User.where(id: params[:id])[0]
		if current_user.level >= @me.level
			@me.level = @me.level + 1
		end
		@me.save
		redirect_to userlist_index_path(id: @me.id)
	end
	def downgrade
		@me = User.where(id: params[:id])[0]
		if current_user.level > @me.level
			@me.level = @me.level - 1
		end
		@me.save
		redirect_to userlist_index_path(id: @me.id)
	end
end

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
end

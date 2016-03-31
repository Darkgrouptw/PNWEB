class DetaillistController < ApplicationController
	def index
		@tags = params[:detail_id]
		@detail = DataDetail.where(id: @tags)
		@detail.each do |d|
			@issue = DataIssue.where(id: d.issue_id)
			@person = DataPerson.where(id: d.people_id)
			@user = User.where(id: d.post_id)
			@strings = detail.comment_id.split(",")
			@comments = DataComment.where(:id => @strings)
		end
	end
end

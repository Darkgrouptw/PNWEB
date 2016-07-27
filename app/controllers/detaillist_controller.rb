class DetaillistController < ApplicationController
	def index
		tags = params[:id]
		#find the data will be used in page
		@me = DataDetail.where(id: tags)[0]
		if @me.nil?
			return
		end
		@issue = DataIssue.where(id: @me.issue_id)[0]
		@user = User.where(id: @me.post_id)[0]
		@person = DataPerson.where(id: @me.people_id)[0]
		comment_id = []
		comment_ids = @me.comment_id.split(',')
		comment_ids.each do |item|
			comment_id.push()
		end
		@comments = DataComment.where(id: comment_id).order(:created_at).reverse
		likelist_id = []
		likelist_ids = @me.like_list_id.split(',')
		
		

	end
end

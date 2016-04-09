class DetaillistController < ApplicationController
	def index
		@all_detail = true
		@tags = params[:detail_id]
		@detail = DataDetail.where(id: @tags)
		if @detail.where(id: @tags).length >= 1
			
			@me = @detail.where(id: @tags)[0]
			@issue = DataIssue.where(id: @me.issue_id)[0]
			@person = DataPerson.where(id: @me.people_id)[0]
			@user = User.where(id: @me.post_id)[0]
			if !@me.comment_id.nil? && !@me.comment_id.empty?
				@strings = @me.comment_id.split(",")
			end
			@comments = DataComment.where(:id => @strings)
			@all_detail = false
		else
			@all_detail = true
		end
	end

	def new
		@comment = DataComment.new
	end

	def create
    end
end

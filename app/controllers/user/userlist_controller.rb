class User::UserlistController < ApplicationController
	def index
		@users = User.all
		@me = @users.where(id: params[:id])[0]
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
	def power_edit
		@me = User.where(id: params[:id])[0]
		if @me.nil?
			return
		end
		if @me.own.nil?
			own_strings = []
		else
			own_strings = @me.own.split(',')
		end
		@AllRootIssue = DataIssue.where(trunk_id: -1)
		@issues = @AllRootIssue.where(id: own_strings)
	end
	def power_update
		@me = User.where(id: params[:id])[0]
		if @me.nil?
			redirect_to userlist_index_path(id: params[:id])
		end
		@AllRootIssue = DataIssue.where(trunk_id: -1)
		own_strings = ""
		@AllRootIssue.each do |issue|
			if params[issue.id.to_s] == "on"
				if own_strings.empty?
					own_strings = own_strings + issue.id.to_s
				else
					own_strings = own_strings + "," + issue.id.to_s
				end
			end
		end
		@me.own = own_strings
		@me.save
		redirect_to userlist_index_path(id: @me.id)
	end
	def all
		@userList = User.all
		redirect_to userlist_index_path(id: @userList[0].id)
	end
end

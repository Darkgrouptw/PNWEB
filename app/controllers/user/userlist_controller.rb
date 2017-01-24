class User::UserlistController < ApplicationController



	def getScore(dataDetail,dataIssue,likeList,user)

		details = dataDetail.where(post_id: user.id,is_report: false)
		issue_ids = []
		details.each do |item|
			issue_ids.push(item.issue_id)
		end
		issues = DataIssue.where(id: issue_ids,is_candidate: false)
		detailIn10Top = 0;

		all_detail = details.where(issue_id: issue_ids)
		all_detail_ids=[]
		all_detail.each do |item|
			all_detail_ids.push(item.id)
		end
		all_likes = likeList.where(detail_id: all_detail_ids)
		details.each do |item|
			issue = issues.where(id: item.issue_id)[0]
			like = all_likes.where(detail_id: issue.datadetail_id.split(','))
			details_temp = details
			details_temp.sort_by{|item| like.where(detail_id: item.id).length}.reverse
			if details_temp.index(details_temp.where(id: item.id)[0]) < 10
				detailIn10Top = detailIn10Top + 1
			end
			#issue_list.sort_by{|item| likelist.where(detail_id: item.datadetail_id.split(',')).length}.reverse
		end
		postedIssueNumber = dataIssue.where(post_id: user.id,is_candidate: false).length

		return detailIn10Top * 3 + details.length * 1 + @postedIssueNumber * 3
	end
	def index
		@user_order = params[:user_order]
		@user_search = params[:user_search]

		
		@me = User.where(id: params[:id])[0]
		@details = DataDetail.where(post_id: @me.id,is_report: false)
		detail_ids = []
		issue_ids = []
		people_ids = []
		@score = 0
		@details.each do |item|
			issue_ids.push(item.issue_id)
			people_ids.push(item.people_id)
			detail_ids.push(item.id)
		end
		@people = DataPerson.where(id: people_ids)
		#Post.where("id = 1").or(Post.where("author_id = 3"))
		#users.where(users[:name].eq('bob').or(users[:age].lt(25)))
		@issues = DataIssue.where(id: issue_ids,is_candidate: false)
		@postedIssueNumber = DataIssue.where(post_id: @me.id,is_candidate: false).length
		@likedNumber = LikeList.where(detail_id: detail_ids).length
		@likeList = LikeList.where(post_id: @me.id)
		@reportedNumber = ReportDetail.where(detail_id: detail_ids).length

		@detailIn10Top = 0
		@all_detail = DataDetail.where(issue_id: issue_ids,is_report: false,is_report: false)
		all_detail_ids=[]
		@all_detail.each do |item|
			all_detail_ids.push(item.id)
		end
		all_likes = LikeList.where(detail_id: all_detail_ids)
		if all_likes.length > 0
			@details.each do |item|
				issue = @issues.where(id: item.issue_id)[0]
				like = all_likes.where(detail_id: issue.datadetail_id.split(','))
				details_temp = @details
				details_temp.sort_by{|item| like.where(detail_id: item.id).length}.reverse
				if details_temp.index(details_temp.where(id: item.id)[0]) < 10
					@detailIn10Top = @detailIn10Top + 1
				end
				#issue_list.sort_by{|item| likelist.where(detail_id: item.datadetail_id.split(',')).length}.reverse
			end
		end
		
		
		@score = @detailIn10Top * 3 + @details.length * 1 + @postedIssueNumber * 3

		if @user_search.nil? || @user_search.empty?
			@users = User.all
		else
			@users = User.where("nickname like ?", "%" + @user_search + "%")
		end

		if @user_order.nil? || @user_order.empty?
			@user_order = "hot"
		end
		if @user_order == "near_hot"
			@users = @users.sort_by{|item| DataIssue.where(created_at: (Time.now.in_time_zone('Taipei') - 7.day)..Time.now.in_time_zone('Taipei')).where(post_id: item.id) + DataDetail.where(created_at: (Time.now.in_time_zone('Taipei') - 7.day)..Time.now.in_time_zone('Taipei')).where(post_id: item.id)}.reverse
			#likelist = LikeList.where( created_at: (Time.now.in_time_zone('Taipei') - 1.day)..Time.now.in_time_zone('Taipei'))
		elsif @user_order == "hot"
			@users = @users.sort_by{|item| DataIssue.where(post_id: item.id).length + DataDetail.where(post_id: item.id).length}.reverse
		else
			@users = @users.sort_by{|item| getScore(DataDetail.all,DataIssue.all,LikeList.all,item)}.reverse
		end


	end

	def upgrade
		@me = User.where(id: params[:id])[0]
		if current_user.level >= @me.level
			@me.level = @me.level + 1
		end
		@me.other = "0"
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
		if @userList.length == 0
			flash[:alert] = "資料中沒有任何媒體"
			redirect_to(:back)
		else
			redirect_to userlist_index_path(id: @userList[0].id)
		end
		
	end

	def disable
		suspended = params[:able]
		user_id = params[:user_id]
		user = User.where(id: user_id)[0]
		if user.nil?
		else
			user.other = suspended.to_s
			user.save
		end
		redirect_to(:back)
	end
end

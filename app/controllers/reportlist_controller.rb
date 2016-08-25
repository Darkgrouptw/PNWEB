class ReportlistController < ApplicationController
  def index
  	@me = ReportDetail.where(id: params[:id])[0]
  	@detail = DataDetail.where(id: @me.detail_id)[0]
  	if !can_editor_issue(1,@detail.issue_id)
		flash[:alert] = "權限不足"
		redirect_to "/"
	end
	
	if @me.nil?
		return
	end
	
	@issue = DataIssue.where(id: @detail.issue_id)[0]

  end
  def all
  	if !can_view(1)
		flash[:alert] = "權限不足"
		redirect_to "/"
	end
	@reportlist = ReportDetail.all.order(:created_at).reverse
	detail_ids = []
	issue_ids = []
	user_ids = []
	@reportlist.each do |item|
		detail_ids.push(item.detail_id)
	end
	@detaillist = DataDetail.where(id: detail_ids)
	@detaillist.each do |item|
		issue_ids.push(item.issue_id)
		user_ids.push(item.post_id)
	end
	@issuelist = DataIssue.where(id: issue_ids)
	@userlist = User.where(id: user_ids)

  end
  def add
	@detail = DataDetail.where(id: params[:id])[0]
  end
  def new
	cause = params[:cause]
	detail_id = params[:detail_id]
	tempStr = ""
        9.times do |i|
            tempTitle = "rule" + (i+1).to_s
            if params[tempTitle] == "on"
                tempStr += (i+1).to_s + ","
            end
        end
	@detail = DataDetail.where(id: detail_id)[0]
	people_id = current_user.id
	@report = ReportDetail.create(
		created_at: Time.now,
		updated_at: Time.now,
		is_check: false,
		)

	@report.people_id = people_id
	@report.detail_id = detail_id
	@report.cause = tempStr

	@detail.is_report = true
	@detail.save
	@report.save
	redirect_to reportlist_all_path

  end

  def reject
  	if !can_editor_issue(1,params[:issue_id])
		flash[:alert] = "權限不足"
		redirect_to "/"
	end
	@detail = DataDetail.where(id: params[:detail_id])[0]
	@reportList = ReportDetail.where(detail_id: @detail.id)
	@issue = DataIssue.where(id: params[:issue_id])[0]
	#check there is any report on the detail
	if @reportList.length < 2
		@detail.is_report = false
	end
	@report = @reportList.where(people_id: current_user.id)[0]
	@report.destroy
	@detail.save
	redirect_to detaillist_index_path(id: @detail.id)
  end

  def accept
  	if !can_editor_issue(1,params[:issue_id])
		flash[:alert] = "權限不足"
		redirect_to "/"
	end
	@detail = DataDetail.where(id: params[:detail_id])[0]
	@reportList = ReportDetail.where(detail_id: @detail.id)
	@report = @reportList.where(id: params[:id])[0]
	@issue = DataIssue.where(id: params[:issue_id])[0]
	@LikeListList = LikeList.where(detail_id: @detail.id)

	#issue
	if @issue.datadetail_id.include?("," + @detail.id.to_s)
		@issue.datadetail_id = @issue.datadetail_id.sub("," + @detail.id.to_s,"")
	else
		@issue.datadetail_id = @issue.datadetail_id.sub(@detail.id.to_s,"")
	end
	
	#likelist 	#notify's user
	users = []
	@LikeListList.each do |item|
		users.push(item.post_id)
		item.destroy
	end
	#commend
	#detail
	@detail.destroy
	#report
	@report.destroy

	#notify
	@notifyList = NotifyList.where(issue_id: @issue.id)
	@userList = User.where(id: users)
	@LikeListList = LikeList.where(post_id: users)
	@notifyList.each do |item|
		user = item.user_id
		like = @LikeListList.where(post_id: user)
		datadetail_id = @issue.datadetail_id.split(',')

		#if user did't like these issue any more => kill it
		stillNotify = false
		like.each do |item|
			if datadetail_id.include?(item.detail_id.to_s)
				stillNotify = true
			end
		end

		if stillNotify
			# donothing
		else
			item.destroy
		end
	end
	@issue.save
	redirect_to reportlist_all_path
  end
end

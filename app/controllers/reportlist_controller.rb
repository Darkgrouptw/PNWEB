class ReportlistController < ApplicationController
  def index
  	@me = ReportDetail.where(id: params[:id])[0]
  	if @me.nil?
  		return
  	end
  	@detail = DataDetail.where(id: @me.detail_id)[0]
  	@issue = DataIssue.where(id: @detail.issue_id)[0]

  end
  def all
  	@reportlist = ReportDetail.all
  	detail_ids = []
  	@reportlist.each do |item|
  		detail_ids.push(item.detail_id)
  	end
  	@detaillist = DataDetail.where(id: detail_ids)

  end
  def add
  	@detail = DataDetail.where(id: params[:id])[0]
  end
  def new
  	cause = params[:cause]
  	detail_id = params[:detail_id]
  	@detail = DataDetail.where(id: detail_id)
  	people_id = current_user.id
  	@report = ReportDetail.create(
  		created_at: Time.now,
  		updated_at: Time.now,
  		is_check: false,
  		)
  	@report.people_id = people_id
  	@report.detail_id = detail_id
  	@report.cause = cause

  	@detail.is_report = true
  	@detail.save
  	@report.save
  	redirect_to reportlist_index_path(id: @report.id)

  end

  def reject
  	@detail = DataDetail.where(id: params[:detail_id])[0]
  	
  	@issue = DataIssue.where(id: params[:issue_id])[0]
  	#check there is any report on the detail
  	if @reportList.length < 2
  		@detail.is_report = false
  	end
  	@detail.save
  	@report.destroy
  	redirect_to detaillist_index_path(id: @detail.id)
  end

  def accept
  	@detail = DataDetail.where(id: params[:detail_id])[0]
  	@reportList = ReportDetail.where(detail_id: @detail.id)
  	@report = @reportList.where(id: params[:id])[0]
  	@issue = DataIssue.where(id: params[:issue_id])[0]
  	@LikeListList = LikeList.where(detail_id: @detail.id)
  	

  	@LikeListList.each do |item|
  		item.destroy
  	end
  	@report.destroy

  	#notify
  	@notifyList = NotifyList.where(issue_id: @issue.id)

  	notifyList.each do |item|
  		
  	end

  	redirect_to reportlist_all_path
  end
end

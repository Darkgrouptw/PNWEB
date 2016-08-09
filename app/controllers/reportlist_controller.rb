class ReportlistController < ApplicationController
  def index
  	@me = ReportDetail.where(id: params[:id])[0]
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
  	people_id = current_user.id
  	@report = ReportDetail.create(
  		created_at: Time.now,
  		updated_at: Time.now,
  		is_check: false,
  		)
  	@report.people_id = people_id
  	@report.detail_id = detail_id
  	@report.cause = cause
  	@report.save
  	redirect_to reportlist_index_path(id: @report.id)

  end

  def reject
  	@report = ReportDetail.where(id: params[:id])[0]
  	@issue = DataIssue.where(id: params[:issue_id])[0]
  	@detail = DataDetail.where(id: params[:detail_id])[0]
  	redirect_to detaillist_index_path(id: @detail.id)
  end

  def accept
  	redirect_to reportlist_all_path
  end
end

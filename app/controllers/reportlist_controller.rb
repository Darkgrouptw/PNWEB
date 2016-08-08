class ReportlistController < ApplicationController
  def index
  end
  def all
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

end

class Dataitems::DataIssuesController < ApplicationController
	def index
		@items = DataIssue.all.order(:id)
		@state = 0
	end

	def new
		@item = DataIssue.new
	end

	def create
		@item = DataIssue.create(params_check)

		@item.count = 0
		@item.agree = 0
		@item.disagree = 0
		if @item.save
			redirect_to dataitems_data_issues_path, notice: "建立成功"
		else
			redirect_to new_dataitems_data_issue_path
		end
	end

	def update
		@item = DataIssue.find(params[:id])

		if @item.update(params_check)
	    	redirect_to dataitems_data_issues_path, notice: "修改成功"
	  	else
	      	render :edit
	  	end
	end

	def edit
		@item = DataIssue.find(params[:id])
	end

	def destroy
		@item = DataIssue.find(params[:id])
		@item.destroy
		redirect_to dataitems_data_issues_path, alert: "刪除成功"
	end

	private

	def params_check
		params.require(:data_issue).permit(:content, :parent_id, :count, :sub_id, :agree, :disagree)
	end
end
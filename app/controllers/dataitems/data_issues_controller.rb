class Dataitems::DataIssuesController < ApplicationController
	def index
		@items = DataIssue.all
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
			flash[:notice] = "成功建立"
			redirect_to dataitems_data_issues_path
		else
			redirect_to new_dataitems_data_issue_path
		end
	end

	def update
	end

	def edit
	end

	def destroy
	end

	private

	def params_check
		params.require(:data_issue).permit(:content, :parent_id, :count, :sub_id, :agree, :disagree)
	end
end

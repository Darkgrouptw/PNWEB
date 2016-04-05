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

        @item.popularity = 0
        @item.datadetail_id = ""
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
        params.require(:data_issue).permit(:title, :post, :is_candidate, :trunk_id, :popularity, :datadetail_id)
	end
end

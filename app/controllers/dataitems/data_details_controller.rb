class Dataitems::DataDetailsController < ApplicationController
	def index
        @items = DataDetail.all.order(:id)
		@state = 2
	end

	def new
        redirect_to dataitems_data_details_path, alert: "請勿使用其他連結"
	end

	def update
        redirect_to dataitems_data_details_path, alert: "請勿使用其他連結"
	end

	def edit
        redirect_to dataitems_data_details_path, alert: "請勿使用其他連結"
	end

	def destroy
		@item = DataDetail.find(params[:id])
		@item.destroy
        redirect_to dataitems_data_details_path, notice: "刪除成功"
	end

	private

	def params_check
        params.require(:data_details).permit(:is_support, :content, :link, :backup_id, :count, :count_like, :count_dislike, :post_id, :people_id, :issue_id, :comment_id)
	end
end

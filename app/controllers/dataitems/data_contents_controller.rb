class Dataitems::DataContentsController < ApplicationController
	def index
		@items = DataContent.all.order(:id)
		@state = 2
	end

	def new
		@item = DataContent.new
	end

	def create
		@item = DataContent.create(params_check)

		if @item.save
			redirect_to dataitems_data_contents_path, notice: "建立成功"
		else
			redirect_to new_dataitems_data_content_path
		end
	end

	def update
		@item = DataContent.find(params[:id])

		if @item.update(params_check)
	    	redirect_to dataitems_data_contents_path, notice: "修改成功"
	  	else
	      	render :edit
	  	end
	end

	def edit
		@item = DataContent.find(params[:id])
	end

	def destroy
		@item = DataContent.find(params[:id])
		@item.destroy
		redirect_to dataitems_data_contents_path, alert: "刪除成功"
	end

	private

	def params_check
		params.require(:data_content).permit(:is_support, :text, :link)
	end
end

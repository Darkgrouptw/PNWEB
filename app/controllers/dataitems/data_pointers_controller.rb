class Dataitems::DataPointersController < ApplicationController
	def index
		@items = DataPointer.all.order(:id)
		@state = 3
	end

	def new
		@item = DataPointer.new
	end

	def create
		@item = DataPointer.create(params_check)

		if @item.save
			redirect_to dataitems_data_pointers_path, notice: "建立成功"
		else
			redirect_to new_dataitems_data_pointers_path
		end
	end

	def update
		@item = DataPointer.find(params[:id])

		if @item.update(params_check)
	    	redirect_to dataitems_data_pointers_path, notice: "修改成功"
	  	else
	      	render :edit
	  	end
	end

	def edit
		@item = DataPointer.find(params[:id])
	end

	def destroy
		@item = DataPointer.find(params[:id])
		@item.destroy
		redirect_to dataitems_data_pointers_path, alert: "刪除成功"
	end

	private

	def params_check
		params.require(:data_pointer).permit(:issue_id, :person_id, :content_id, :pic_link)
	end
end

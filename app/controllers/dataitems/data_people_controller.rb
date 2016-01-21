class Dataitems::DataPeopleController < ApplicationController
	def index
		@items = DataPerson.all
		@state = 1
	end

	def new
		@item = DataPerson.new
	end

	def create
		@item = DataPerson.create(params_check)

		if @item.save
			redirect_to dataitems_data_people_path, notice: "建立成功"
		else
			redirect_to new_dataitems_data_person_path
		end
	end

	def update
		@item = DataPerson.find(params[:id])

		if @item.update(params_check)
	    	redirect_to dataitems_data_people_path, notice: "修改成功"
	  	else
	      	render :edit
	  	end
	end

	def edit
		@item = DataPerson.find(params[:id])
	end

	def destroy
		@item = DataPerson.find(params[:id])
		@item.destroy
		redirect_to dataitems_data_people_path, alert: "刪除成功"
	end

	private

	def params_check
		params.require(:data_person).permit(:name, :pic_link)
	end
end

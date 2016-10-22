class PeoplelistController < ApplicationController
	def index

		@tags = params[:id]
		@people = DataPerson.all;
		@me = @people.where(name: @tags)[0]
		if @me.nil?
			return
		end
		issue_ids = []
		#find all the detail is said by the @me
		@details = DataDetail.where(people_id: @me.id,is_report: false)
		@details.each do |detail|
			issue_ids.push(detail.issue_id)
		end
		#find all the issue connect with details
		@issues = DataIssue.where(id: issue_ids,is_candidate: false)

	end
	def add
		if !can_view(2)
			flash[:alert] = "權限不足"
			redirect_to "/"
		end
	end
	def new 
		if !can_view(2)
			flash[:alert] = "權限不足"
			redirect_to "/"
		end
		name = params[:name]
		pic_link = params[:pic_link]
		description = params[:description]
		if !DataPerson.where(name: name)[0].nil?
			flash[:alert] = "此名人已存在"
			redirect_to(:back)
			return
		end
		@person = DataPerson.create(created_at: Time.now.in_time_zone('Taipei'),updated_at: Time.now.in_time_zone('Taipei'))
		@person.name = name
		@person.pic_link = pic_link
		@person.description = description
		@person.save
		redirect_to peoplelist_index_path(id: @person.name)
	end
	def edit
		if !can_view(2)
			flash[:alert] = "權限不足"
			redirect_to "/"
		end
		@tags = params[:id]
		@person = DataPerson.where(name: @tags)[0]
	end
	def update
		if !can_view(2)
			flash[:alert] = "權限不足"
			redirect_to "/"
		end
		@person = DataPerson.where(id: params[:id])[0]
		if !(params[:name].nil? || params[:name].empty?)
			@person.name = params[:name]
		end
		if !(params[:description].nil? || params[:description].empty?)
			@person.description = params[:description]
		end
		if !(params[:pic_link].nil? || params[:pic_link].empty?)
			@person.pic_link = params[:pic_link]
		end
		@person.save
		redirect_to peoplelist_index_path(id: @person.name)
	end
	def all
		@persons=DataPerson.all
	end
end

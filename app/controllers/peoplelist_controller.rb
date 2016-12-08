class PeoplelistController < ApplicationController
	def findNearHotPeople(people_list)
		likelist = LikeList.all
		return people_list.sort_by{|item| likelist.where(created_at: (Time.now.in_time_zone('Taipei') - 1.day)..Time.now.in_time_zone('Taipei')).where(detail_id: item.datadetail_id.split(',')).length}.reverse
	end

	def findInfluencePeople(people_list)
		
		return people_list.sort_by{|item|  getStringIDLength(item.datadetail_id)}.reverse
	end

	def index

		@tags = params[:id]
		@all_people = DataPerson.all;
		@people_order = params[:people_order]
		@people_search = params[:people_search]
		@issue_order = params[:issue_order]
		@issue_search = params[:issue_search]

		@me = @all_people.where(name: @tags)[0]
		if @me.nil?
			return
		end

		if @people_search.nil? || @people_search.empty?
			#@issues = DataIssue.where(is_candidate: false).where("title like ?", name + "%").first(5)
			@people = @all_people
		else
			@people = @all_people.where("name like ?", "%" + @people_search + "%")
		end

		if @people_order == "time"
			@people = @people.order(created_at: :desc)
		elsif @people_order == "influence"
			@people = findInfluencePeople(@people)
		else
			@people = findNearHotPeople(@people)
		end


		issue_ids = []
		#find all the detail is said by the @me
		@details = DataDetail.where(people_id: @me.id,is_report: false).order(:created_at)
		@details.each do |detail|
			issue_ids.push(detail.issue_id)
		end
		#find all the issue connect with details
		if @issue_search.nil? || @issue_search.empty?
			@issue_search = ""
		end
		@issues = DataIssue.where("title like ?","%" + @issue_search + "%").where(id: issue_ids,is_candidate: false)
		if @issue_order == ""
			@issues = @issues
		end

	end
	def add
		if !can_add_detail()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
		end
	end
	def new 
		if !can_add_detail()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
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
		if !can_editor_detail()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
		end
		@tags = params[:id]
		@person = DataPerson.where(name: @tags)[0]
	end
	def update
		if !can_editor_detail()
			flash[:alert] = "權限不足"
			redirect_to(:back)
			return
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
		if @persons.length == 0
			flash[:alert] = "資料中沒有任何媒體"
			redirect_to(:back)
		else
			redirect_to peoplelist_index_path(id: @persons[0].name)
		end
		
	end
end

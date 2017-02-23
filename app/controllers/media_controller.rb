class MediaController < ApplicationController

	def findInfluenceMedia(media_list)
		
		return media_list.sort_by{|item|  getStringIDLength(item.datadetail_id)}.reverse
	end
	def index
  		@tags = params[:id]
		@media = DataMedium.all;
		@media_order = params[:media_order]
		@media_search = params[:media_search]
		@issue_order = params[:issue_order]
		@issue_search = params[:issue_search]

		@me = @media.where(name: @tags)[0]
		if @me.nil?
			return
		end

		if @media_search.nil? || @media_search.empty?
			#@issues = DataIssue.where(is_candidate: false).where("title like ?", name + "%").first(5)
			@media = @media
		else
			@media = @media.where("name like ?", "%" + @media_search + "%")
		end

		if @media_order == "time"
			@media = @media.order(created_at: :desc)
		else
			@media = findInfluenceMedia(@media)
		end

		issue_ids = []
		people_ids = []
		#find all the detail is said by the @me
		@details = DataDetail.where(news_media: @me.name,is_report: false)
		@details.each do |detail|
			issue_ids.push(detail.issue_id)
			people_ids.push(detail.people_id)
		end
		#find all the issue connect with details
		@people = DataPerson.where(id: people_ids)

		if @issue_search.nil? || @issue_search.empty?
			@issue_search = ""
		end
		@issues = DataIssue.where("title like ?","%" + @issue_search + "%").where(id: issue_ids,is_candidate: false)
		#@issues = DataIssue.where(id: issue_ids,is_candidate: false)
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
		if !DataMedium.where(id: id)[0].nil?
			flash[:alert] = "此媒體已存在"
			redirect_to(:back)
			return
		end
		@media = DataMedium.create(created_at: Time.now.in_time_zone('Taipei'),updated_at: Time.now.in_time_zone('Taipei'))
		@media.name =name
		@media.valid_name = ""
		@media.description = ""
		@media.datadetail_id = ""
		@person = DataPerson.create(created_at: Time.now.in_time_zone('Taipei'),updated_at: Time.now.in_time_zone('Taipei'))
		redirect_to(:back)
	end
	def all
		@medias = DataMedium.all
		if @medias.length == 0
			flash[:alert] = "資料中沒有任何媒體"
			redirect_to(:back)
		else
			redirect_to media_index_path(@medias[0].name)
		end
		
	end

	def hide
		puts "======================================================================================"
		id = params[:Name]
		puts id
		puts "======================================================================================"
		media = DataMedium.where(id: id)[0]
		if !media.nil?
			if getOtherParameter(media,"hide") == "yes"
				setOtherParameter(media,"hide","no")
			else
				setOtherParameter(media,"hide","yes")
			end
			media.save
		end
		return
	end
end

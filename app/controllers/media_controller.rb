class MediaController < ApplicationController
	def index
  		@tags = params[:id]
		@media = DataMedium.all;
		@me = @media.where(name: @tags)[0]
		if @me.nil?
			return
		end
		issue_ids = []
		#find all the detail is said by the @me
		@details = DataDetail.where(news_media: @me.name,is_report: false)
		@details.each do |detail|
			issue_ids.push(detail.issue_id)
		end
		#find all the issue connect with details
		@issues = DataIssue.where(id: issue_ids,is_candidate: false)
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
		redirect_to media_index_path(@medias[0].name)
	end
end

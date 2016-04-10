class DetaillistController < ApplicationController
	def index
		@all_detail = true
		@tags = params[:detail_id]
		@detail = DataDetail.where(id: @tags)
		if @detail.where(id: @tags).length >= 1
			
			@me = @detail.where(id: @tags)[0]
			@issue = DataIssue.where(id: @me.issue_id)[0]
			@person = DataPerson.where(id: @me.people_id)[0]
			@user = User.where(id: @me.post_id)[0]
			if !@me.comment_id.nil? && !@me.comment_id.empty?
				@strings = @me.comment_id.split(/,/)
				@comments = DataComment.where(id: @strings).order(:created_at).reverse
				@strings2 = Array.new
				@comments.each do |comment|
					@strings2.push(comment.post_id)
				end
				@talkers = User.where(id: @strings2)
			end
			
			@all_detail = false
		else
			@all_detail = true
		end
	end

	def new
		@comment = DataComment.new
	end

	def create
		@comment = DataComment.create(comment_params)
		@comment.post_id = current_user.id
		if @comment.save
			@tags = params[:detail_id]
			@detail = DataDetail.where(:id => @tags)[0]
			@detail.comment_id = @detail.comment_id + @comment.id.to_s + ","
			@detail.update(comment_id: @detail.comment_id)
			redirect_to detaillist_path+"/"+@tags
		else
			render :new
		end
    end

    def detail_params
        params.require(:data_detail).permit(:is_support, :content, :link, :count, :count_like, :count_dislike, :post_id, :people_id, :issue_id, :comment_id, :comment_id, :issue_id)
    end
    
    def issue_params
        params.require(:data_detail).permit(:datadetail)
    end

    def comment_params
    	params.require(:data_comment).permit(:content)
    end
end

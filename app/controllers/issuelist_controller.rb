class IssuelistController < ApplicationController

	def index
		@tags = params[:id]
		@issues = DataIssue.all.order(:created_at)
		@me = @issues.where(id: @tags)[0]
		if @me ==nil
			return
		end
		detail_strings = @me.datadetail_id.split(/,/)
		@details = DataDetail.where(id: @strings)
		@likeList = LikeList.where(post_id: current_user)

		user = []
		person = []

		# 要判斷是用什麼來排序
		if params[:orderby] == "Time"
			@support = @details.where(is_support: true).order(:created_at).reverse
			@disSupport = @details.where(is_support: false).order(:created_at).reverse
		else
			@support = @details.where(is_support: true)
			@disSupport = @details.where(is_support: false)
			# 計算讚數來以排序 boble sort
			for i in 0..@support.length - 1
				length_i = 0
				text_i = @support[i].like_list_id
				length_i = text_i.split(',').length
				for j in 0..i
					length_j = 0
					text_j = @support[i].like_list_id
					length_j = text_j.split(',').length

					if length_j < length_i
						temp = @support[i]
						@support[i] = @support[j]
						@support[j] = temp
					end
				end
			end
			for i in 0..@disSupport.length - 1
				length_i = 0
				text_i = @disSupport[i].like_list_id
				length_i = text_i.split(',').length
				for j in 0..i
					length_j = 0
					text_j = @disSupport[i].like_list_id
					length_j = text_j.split(',').length

					if length_j < length_i
						temp = @disSupport[i]
						@disSupport[i] = @disSupport[j]
						@disSupport[j] = temp
					end
				end
			end
		end
	end

	def add
	end

	def all
		@issues = DataIssue.where(trunk_id: -1).order(:created_at)
	end
end

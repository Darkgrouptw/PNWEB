class IssuelistController < ApplicationController
	def findNearHotIssue(issue_list)
        likelist = LikeList.where( created_at: (Time.now.in_time_zone('Taipei') - 1.day)..Time.now.in_time_zone('Taipei'))
        counter = []
        recorder = [];
        issue_list.each do |issue|
            counter.push(0);
            recorder.push(issue.id);
        end
        likelist.each do |like|
            for i in 0..counter.length - 1
                issue = issue_list.where(id: recorder[i])[0]
                if stringHasID(issue.datadetail_id,like.detail_id)
                    counter[i] = counter[i] + 1
                end
            end
        end
        for i in 0..counter.length - 1
            for j in 0..counter.length - i - 2
                if counter[j] < counter[j + 1]
                    temp = counter[j]
                    counter[j] = counter[j + 1]
                    counter[j + 1] = temp
                    temp = recorder[j]
                    recorder[j] = recorder[j + 1]
                    recorder[j + 1] = temp
                end
            end
        end
        result = []
        recorder.each do |record|
            result.push(issue_list.where(id: record)[0])
        end
        return result
    end
    def findHotIsssue(issue_list)
    	likelist = LikeList.all
        #counter = []
        #recorder = [];
        #issue_list.each do |issue|
        #    counter.push(0);
        #    recorder.push(issue.id);
        #end
        #likelist.each do |like|
        #    for i in 0..counter.length - 1
        #        issue = issue_list.where(id: recorder[i])[0]
        #        if stringHasID(issue.datadetail_id,like.detail_id)
        #            counter[i] = counter[i] + 1
        #        end
        #    end
        #end
        #for i in 0..counter.length - 1
        #    for j in 0..counter.length - i - 2
        #        if counter[j] < counter[j + 1]
        #            temp = counter[j]
        #            counter[j] = counter[j + 1]
        #            counter[j + 1] = temp
        #            temp = recorder[j]
        #            recorder[j] = recorder[j + 1]
        #            recorder[j + 1] = temp
        #        end
        #    end
        #end
        #result = []
        #recorder.each do |record|
        #    result.push(issue_list.where(id: record)[0])
        #end
        #return result
        #@issues = @issues.sort_by{|item| item.datadetail_id.length}.reverse
        return issue_list.sort_by{|item| likelist.where(detail_id: item.datadetail_id.split(',')).length}.reverse
        
    end
	def findReferenceIssue(me,issue_list)
		if issue_list.nil? || issue_list.length == 0
			return nil
		end
		issue_ids = []
		me_tags = me.tag.split(',')
		issue_list.each do |issue|
			if issue.id == me.id
			else
				issue_tags = issue.tag.split(',')
				me_tags.each do |tag|
					if issue_tags.include? tag
						issue_ids.push(issue.id)
						break
					end
				end	
			end
		end
		return issue_list.where(id: issue_ids)
	end

	def findDownIssueIds(issue)
		all_nodes = TreeLink.all
		nodes =  all_nodes.where(issue_id: issue.id)
		issue_ids = []
		nodes.each do |node|
			donwNodes = nodes.where(id: node.children_id)[0]
			#issue_ids.push(donwNodes.issue_id)
			issue_ids.push(node.children_id)
		end
		return issue_ids;
	end
	def index
		@tags = params[:id]
		@pos_order = params[:pos_order]
		@neg_order = params[:neg_order]
		@pos_show = params[:pos_show]
		@neg_show = params[:neg_show]
		@all_issue = DataIssue.where(is_candidate: false)
		@issues = @all_issue.where(is_candidate: false).order(:created_at)
		@me = @issues.where(id: @tags)[0]
		if @pos_order.nil? || @pos_order.empty?
			@pos_order = "thumb"
		end
		if @neg_order.nil? || @neg_order.empty?
			@neg_order = "thumb"
		end
		if @pos_show.nil? || @pos_show.empty?
			@pos_show = "table"
		end
		if @neg_show.nil? || @neg_show.empty?
			@neg_show = "table"
		end
		if @me ==nil
			flash[:alert] = "議題不存在"
			redirect_to (:back)
			return
		end
		@reports = nil
		if !current_user.nil?
			detail_ids = @me.datadetail_id.split(',')
			@reports = ReportDetail.where(detail_id: detail_ids,people_id: current_user.id)
		end
		detail_strings = @me.datadetail_id.split(',')
		@details = DataDetail.where(id: detail_strings,is_report: false)
		@AllLike = LikeList.where(detail_id: detail_strings)
		#@likeList = LikeList.where(post_id: current_user)
		@likeList = @AllLike.where(post_id: current_user)
		# 判斷是否讚太多
		likeLimit = 3
		likeNumber = 0
		posLikeNumber = 0
		negLikeNumber = 0
		@NoMoreLike = false
		@NoMorePosLike = false
		@NoMoreNegLike = false
		@details.each do |detail|
			like = @likeList.where(detail_id: detail.id)[0]
			if !like.nil?
				if detail.is_support
					posLikeNumber = posLikeNumber + 1
				else
					negLikeNumber = negLikeNumber + 1
				end
				likeNumber = likeNumber + 1
			end
		end
		if likeNumber >= likeLimit
			@NoMoreLike = true
		end
		if posLikeNumber >= likeLimit
			@NoMorePosLike = true
		end
		if negLikeNumber >= likeLimit
			@NoMoreNegLike = true
		end
		# 要判斷是不是只要直接意見
		@support = @details.where(is_support: true)
		if @pos_show == "table"
		else
			@support = @support.where(is_direct: true)
		end
		@disSupport = @details.where(is_support: false)
		if @neg_show == "table"
		else
			@disSupport = @disSupport.where(is_direct: true)
		end
		# 要判斷是用什麼來排序
		if @pos_order == "time"
			@support = @support.order(:created_at).reverse
		else
			for i in 0..@support.length - 1
				length_i = 0
				text_i = @support[i].like_list_id
				length_i = @likeList.where(detail_id: @support[i].id).length
				for j in 0..i
					length_j = 0
					text_j = @support[i].like_list_id
					length_j = @likeList.where(detail_id: @support[j].id).length

					if length_j < length_i
						temp = @support[i]
						@support[i] = @support[j]
						@support[j] = temp
					end
				end
			end
		end
		if @neg_order == "time"
			@disSupport = @disSupport.order(:created_at).reverse
		else
			for i in 0..@disSupport.length - 1
				length_i = 0
				text_i = @disSupport[i].like_list_id
				length_i = @likeList.where(detail_id: @disSupport[i].id).length
				for j in 0..i
					length_j = 0
					text_j = @disSupport[i].like_list_id
					length_j = @likeList.where(detail_id: @disSupport[j].id).length

					if length_j < length_i
						temp = @disSupport[i]
						@disSupport[i] = @disSupport[j]
						@disSupport[j] = temp
					end
				end
			end
		end
		#判斷顯示的頁數
		@numberPerPage = 5
		@PageExtend = 2
		@negative_page = 0
		@positive_page = 0
		@positive_page = params[:positive_page] 
		@negative_page = params[:negative_page]
		if(@positive_page.nil? || @positive_page.empty?)
			@positive_page = 0 
		end
		if(@negative_page.nil? || @negative_page.empty?)
			@negative_page = 0
		end
		@PositiveHasNextPage = true
		@PositiveHasLastPage = false
		@NegativeHasNextPage = true
		@NegativeHasLastPage = false
		if(@positive_page.to_i > 0)
			@PositiveHasLastPage = true
		end
		if(@negative_page.to_i > 0)
			@NegativeHasLastPage = true
		end
		if( (@negative_page.to_i + 1 ) * @numberPerPage > @disSupport.length)
			@NegativeHasNextPage = false
		end
		if( (@positive_page.to_i + 1 ) * @numberPerPage > @support.length)
			@PositiveHasNextPage = false
		end

		#增加名人 編者
		user = []
		person = []
		media = []
		for i in 0..@numberPerPage-1
			index = @numberPerPage * @positive_page.to_i + i
			if(@support.length > index)
				user.push(@support[index].post_id)
				person.push(@support[index].people_id)
				media.push(@support[index].news_media)
			end
			index = @numberPerPage * @negative_page.to_i + i
			if(@disSupport.length > index)
				user.push(@disSupport[index].post_id)
				person.push(@disSupport[index].people_id)
				media.push(@disSupport[index].news_media)
			end
		end

		#update Notify
		if !current_user.nil?
			@notifyList =  NotifyList.where(user_id: current_user.id , issue_id: @me.id)[0]
			if !@notifyList.nil?
				@notifyList.last_read = Time.now.in_time_zone('Taipei')
				@notifyList.save
			end
		end
		@totalDetailNumber = @details.length
		@totalLikeNumber = @AllLike.length
		@users=User.where(id: user)
		@persons=DataPerson.where(id: person)
		@medias = DataMedium.where(name: media)
		@ReferenceIssue = findReferenceIssue(@me,@all_issue)
		downIssueIds = findDownIssueIds(@me);
		@DownFlowIssue = @all_issue.where(id: downIssueIds)
		#@ReferenceIssueTree = findReferenceIssueTree(@me)
	end

	def add
		if !can_add_issue()
			flash[:alert] = "權限不足"
			redirect_to (:back)
			return
		end
		@suggest = params[:suggest]
		if DataIssue.where(title: @suggest).length == 0
			@suggest = ""
		end
	end

	def new
		if !can_add_issue()
			flash[:alert] = "權限不足"
			redirect_to (:back)
			return
		end
		title = params[:title]
		post = params[:post]
		tag = params[:tag]
		suggest1 = params[:suggest1]
		suggest2 = params[:suggest2]
		suggest3 = params[:suggest3]

		if !tag.nil? || !tag.empty?
			tagStr = tag.split(',')
			if tagStr.length < 3
				flash[:alert] = "議題標籤不得少於3項"
				redirect_to (:back)
				return
			elsif tagStr.length > 10
				flash[:alert] = "議題標籤不得少於10項"
				redirect_to (:back)
				return
			end
		else
			flash[:alert] = "標籤遺失"
			redirect_to (:back)
			return
		end
		if !DataIssue.where(title: title)[0].nil?
			flash[:alert] = "此議題已存在" 
			redirect_to(:back) 
			return
		end

		
		@issue = DataIssue.new(created_at: Time.now.in_time_zone('Taipei'),updated_at: Time.now.in_time_zone('Taipei'))
		@issue.title = title
		@issue.post = post
		@issue.is_hide = false
		@issue.post_id = current_user.id
		@issue.tag = tag
		@issue.suggest_father = ""
		@issue.is_candidate = true
		@issue.thumb_up = ""
		@issue.datadetail_id = ""
		@issue.save
		if suggest1.nil? || suggest1.empty?
		else
			father_issues = DataIssue.where(title: suggest1)
			if father_issues.length > 0
				father_issue = father_issues[0]
				father_issue.suggest_father = addIDToString(father_issue.suggest_father,@issue.id)
				father_issue.save
			end
		end
		if suggest2.nil? || suggest2.empty?
		else
			father_issues = DataIssue.where(title: suggest2)
			if father_issues.length > 0
				father_issue = father_issues[0]
				father_issue.suggest_father = addIDToString(father_issue.suggest_father,@issue.id)
				father_issue.save
			end
		end
		if suggest3.nil? || suggest3.empty?
		else
			father_issues = DataIssue.where(title: suggest3)
			if father_issues.length > 0
				father_issue = father_issues[0]
				father_issue.suggest_father = addIDToString(father_issue.suggest_father,@issue.id)
				father_issue.save
			end
		end
		redirect_to issuelist_all_path
	end

	def edit
		if !can_editor_issue()
			flash[:alert] = "權限不足"
			redirect_to (:back)
			return
		end
		@issue = DataIssue.where(id: params[:id])[0]
	end

	def update
		if !can_editor_issue()
			flash[:alert] = "權限不足"
			redirect_to (:back)
			return
		end
		@issue = DataIssue.where(id: params[:id])[0]

		if @issue.nil?
			return
		end
		if !(params[:title].nil? || params[:title].empty?)
			@issue.title = params[:title]
		end
		if !(params[:post].nil? || params[:post].empty?)
			@issue.post = params[:post]
		end
		tag = params[:tag]
		if !tag.nil? || !tag.empty?
			tagStr = tag.split(',')
			if tagStr.length < 3
				flash[:alert] = "議題標籤不得少於3項"
				redirect_to (:back)
				return
			elsif tagStr.length > 10
				flash[:alert] = "議題標籤不得少於10項"
				redirect_to (:back)
				return
			else
				@issue.tag = params[:tag]
			end
		else
			flash[:alert] = "標籤遺失"
			redirect_to (:back)
			return
		end
		@issue.updated_at = Time.now.in_time_zone('Taipei')
		@issue.save
		redirect_to issuelist_index_path(id: @issue.id)
	end

	def all
		@all_issues = DataIssue.all.order(:created_at)
		@users = User.all
		@candidated_order = params[:candidated_order]
		@issue_order = params[:issue_order]
		@candidated_search = params[:candidated_search]
		@issue_search = params[:issue_search]
		@show_hide = params[:show_hide]
		@issues
		@candidates
		@AllLike = LikeList.all
		if @issue_search.nil? || @issue_search.empty?
			#@issues = DataIssue.where(is_candidate: false).where("title like ?", name + "%").first(5)
			@issues = @all_issues.where(is_candidate: false)
		else
			@issues = @all_issues.where(is_candidate: false).where("title like ?", "%" + @issue_search + "%")
		end
		if @candidated_search.nil? || @candidated_search.empty?
			@candidates = @all_issues.where(is_candidate: true)
		else
			@candidates = @all_issues.where(is_candidate: true).where("title like ?", "%" + @candidated_search + "%")
		end

		if @issue_order == "time"
			@issues = @issues.order(created_at: :desc)
		elsif @issue_order == "hot"
			@issues = findHotIsssue(@issues)
			#@issues.sort_by{|item| item.datadetail_id.length}
		else
			#@issues = @issues.sort_by{|item| item.datadetail_id.length}.reverse
			@issues = findNearHotIssue(@issues)
		end
		
		if @show_hide == "true"

		else
			@candidates = @candidates.where(is_hide: false)
		end

		if @candidated_order == "time"
			@candidates = @candidates.order(created_at: :desc)
		else
			@candidates = findNearHotIssue(@candidates)
		end
				

	end

	def candidate
		@issueList = DataIssue.all
		if params[:order] == "time"
			@issues = @issueList.where(is_candidate: true).order(:created_at).reverse
		elsif params[:order] == "thumb_up"
			@issues = @issueList.where(is_candidate: true).order(:thumb_up).reverse
		elsif params[:order] == "thumb_up_day"
			@issues = @issueList.where(is_candidate: true).where(updated_at: (Time.now.in_time_zone('Taipei') - 1.day)..Time.now.in_time_zone('Taipei')).order(:thumb_up).reverse
		else
			@issues = @issueList.where(is_candidate: true).order(:created_at).reverse
		end
	end

	def thumb_up
    	if !can_like()
			flash[:alert] = "權限不足"
			redirect_to (:back)
			return
		end
		post_id = current_user.id
		@issue = DataIssue.where(id: params[:id])[0]
		if @issue.thumb_up.nil?
			@issue.thumb_up = ""
		end
		if @issue.thumb_up.empty?
			@issue.thumb_up = @issue.thumb_up + post_id.to_s
		else
			@issue.thumb_up = @issue.thumb_up + "," + post_id.to_s
		end
		@issue.save
		redirect_to (:back)
	end

	def upgrade
		if !can_level_up_issue()
			flash[:alert] = "權限不足"
			redirect_to (:back)
			return
		end
		@issue = DataIssue.where(id: params[:id])[0]
		@issue.is_candidate = false
		@issue.created_at = Time.now.in_time_zone('Taipei')
		@issue.save
		redirect_to (:back)
		#redirect_to issuelist_index_path(id: @issue.id)
	end

	def toggle(attribute)
		self[attribute] = !send("#{attribute}?")
		self
	end

	def hide
		puts "======================================================================================"
		id = params[:Name]
		puts id
		puts "======================================================================================"
		issue = DataIssue.where(id: id)[0]
		if !issue.nil?
			if issue.is_candidate
				issue.is_hide = !issue.is_hide
				issue.save
			end
		end
		return
	end
end

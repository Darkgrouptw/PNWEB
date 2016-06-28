class IssuelistController < ApplicationController
    before_filter :authenticate_user!, only: [:new, :create]
    
    #module Vote_state
    #    NO_VOTE = 1
    #    SUPPORT_VOTE = 2
    #    DISSUPPORT_VOTE = 3
    #end

	def index
		@tags = params[:issue_id]
		@issues=DataIssue.all.order(:created_at)
		@all_issue = true
		if @issues.where(id: @tags).length >= 1
			@me = @issues.where(id: @tags)[0]
			@strings = @me.datadetail_id.split(/,/)
			@details = DataDetail.where(id: @strings)
            @likeDislikeList = LikeDislikeList.where(post_id: current_user)


            user = []
            person = []
            
            # 要判斷是用什麼來排序
            if params[:orderby] == "Time"
                @detail_supprot = @details.where(is_support: true).where(is_report: false).order(:created_at).reverse
                @detail_disSupport = @details.where(is_support: false).where(is_report: false).order(:created_at).reverse
            else
                @detail_supprot = @details.where(is_support: true).where(is_report: false)
                @detail_disSupport = @details.where(is_support: false).where(is_report: false)
                for i in 0..@detail_supprot.length - 1
                    length_i = 0
                    text_i = @detail_supprot[i].like_dislike_list_id
                    if text_i != nil && text_i.split('|')[0] != nil
                        length_i = text_i.split('|')[0].split(',').length
                    else
                        length_i = 0
                    end
                    for j in 0..i
                        length_j = 0
                        text_j = @detail_supprot[j].like_dislike_list_id
                        if text_j != nil && text_j.split('|')[0] != nil
                            length_j = text_j.split('|')[0].split(',').length
                        else
                            length_j = 0
                        end

                        if length_j < length_i
                            temp = @detail_supprot[i]
                            @detail_supprot[i] = @detail_supprot[j]
                            @detail_supprot[j] = temp
                        end
                    end
                end
                for i in 0..@detail_disSupport.length - 1
                    length_i = 0
                    text_i = @detail_disSupport[i].like_dislike_list_id
                    if text_i != nil && text_i.split('|')[0] != nil
                        length_i = text_i.split('|')[0].split(',').length
                    else
                        length_i = 0
                    end
                    for j in 0..i
                        length_j = 0
                        text_j = @detail_disSupport[j].like_dislike_list_id
                        if text_j != nil && text_j.split('|')[0] != nil
                            length_j = text_j.split('|')[0].split(',').length
                        else
                            length_j = 0
                        end

                        if length_j < length_i
                            temp = @detail_disSupport[i]
                            @detail_disSupport[i] = @detail_disSupport[j]
                            @detail_disSupport[j] = temp
                        end
                    end
                end
            end
            
            @numberPerPage = 5
            @PageExtend = 2
            @postive_page = "0"
            @negative_page = "0"
            if(params[:positive_page] != nil)
                @postive_page = params[:positive_page] 
            end
            if(params[:negative_page] != nil)
                @negative_page = params[:negative_page]
            end
            @PositiveHasNextPage = true
            @PositiveHasLastPage = false
            @NegativeHasNextPage = true
            @NegativeHasLastPage = false
            if(@postive_page.to_i > 0)
                @PositiveHasLastPage = true
            end
            if(@negative_page.to_i > 0)
                @NegativeHasLastPage = true
            end
            if( (@negative_page.to_i + 1 ) * @numberPerPage > @detail_disSupport.length)
                @NegativeHasNextPage = false
            end
            if( (@postive_page.to_i + 1 ) * @numberPerPage > @detail_supprot.length)
                @PositiveHasNextPage = false
            end

            for i in 0..@numberPerPage-1
                index = @numberPerPage * @postive_page.to_i + i
                if(@detail_supprot.length > index)
                    user.push(@detail_supprot[index].post_id)
                    person.push(@detail_supprot[index].people_id)
                end
                index = @numberPerPage * @negative_page.to_i + i
                if(@detail_disSupport.length > index)
                    user.push(@detail_disSupport[index].post_id)
                    person.push(@detail_disSupport[index].people_id)
                end
            end

			@users=User.where(id: user)
            @persons=DataPerson.where(id: person)
			@all_issue = false
		else
			@all_issue = true
		end
	end
    
    def new
        if current_user == nil
            flash[:alert] = "請先登入!!"
            redirect_to :back
        else
            @detail = DataDetail.new
        end
    end
    
    def create
        puts "-------------------------------"
        puts "Create DataDetail"
        puts "-------------------------------"
        @detail = DataDetail.create(detail_params)
        @detail.issue_id = params[:issue_id]
        @detail.count = 0
        @detail.is_report = false
        @detail.backup_id = @detail.issue_id.to_s+"_"+@detail.id.to_s
        puts "-------------------------------"
        puts "Require Start"
        puts "-------------------------------"
        require "uri"
        require "net/http"
        require "open-uri"
        require 'json'
        
        puts "-------------------------------"
        puts "Require End"
        puts "-------------------------------"
        api = "http://api.page2images.com/directlink?"
        rest_api = "http://api.page2images.com/restfullink"
        p2i_callback = "https://npweb.herokuapp.com/p2i_callback/"+@detail.backup_id.to_s
        url = @detail.link
        p2i_device = "6"
        p2i_screen="1024x768"
        p2i_size="1024x0"
        p2i_fullpage="1"
        p2i_key="8e549b1ac48187d3"
        rest_key="42b2fe10a13f636c"
        p2i_wait="0"
        
        puts "-------------------------------"
        puts "Parameters"
        puts "-------------------------------"
        parameters = {
            "p2i_url" => url,
            "p2i_key" => rest_key,
            "p2i_device" => p2i_device,
            "p2i_size" => p2i_size,
            "p2i_screen" => p2i_screen,
            "p2i_fullpage" => p2i_fullpage,
            "p2i_wait" => p2i_wait
            }
        
        if current_user == nil
            flash[:alert] = "請先登入!!"
            redirect_to :back
        else
            @detail.post_id = current_user.id
            @detail.comment_id = ""
            if @detail.save
                # 開一個 Thread 去取東西
                prossing = true
                Thread.new do
                    maxWatingTime = 60
                    start_time = Time.new 
                    
                    while(prossing && (Time.new - start_time) < maxWatingTime)
                        resp = Net::HTTP.post_form(URI(rest_api), parameters)
                        resp_text = resp.body
                        result = JSON.parse(resp.body)
                        puts "000000000000000000"
                        puts resp.body
                        puts "000000000000000000"
                        if result["status"] == "finished"
                            puts "-------------------------------"
                            puts "Save the File"
                            puts "-------------------------------"
                            open('public/pageBackUp/'+@detail.issue_id.to_s + "_"+@detail.id.to_s+'.png','wb')do |file|
                                file << open(result["image_url"]).read
                            end
                            puts "-------------------------------"
                            puts "Finish"
                            puts "-------------------------------"
                            prossing = false
                        elsif result["status"] == "processing"
                            sleep(5);
                        end
                    end
                end
                
                @tags = params[:issue_id]
                @issue = DataIssue.where(:id => @tags)[0]
                @issue.datadetail_id = @issue.datadetail_id + @detail.id.to_s + ","
                @issue.update(issue_params)
                if(prossing)
                    flash[:alert] = "圖片正在備份中"
                else
                    flash[:notice] = "傳送成功"
                end
                redirect_to issuelist_path+"/"+@issue.id.to_s
            else
                render :new
            end
        end
    end
    
    #
    # 議題 report 之後，要把東西議題的 is_report 設為 true，然後新增一筆資料在 ReportDetail 裡 
    #
    def report
        tempStr = ""
        9.times do |i|
            tempTitle = "rule" + (i+1).to_s
            if params[tempTitle] == "on"
                tempStr += (i+1).to_s + ","
            end
        end
        
        # 假設檢舉是空的
        if tempStr == ""
            flash[:warning] = "檢舉原因不能為空的！！"
            redirect_to(:back)
            return
        end
        
        @report = ReportDetail.create(detail_id: params[:detail_id], is_check: false, cause: tempStr)
        @detail = DataDetail.where(id: params[:detail_id])[0]
        @detail.update(is_report: true)
        if @report.save
            redirect_to "/issuelist/" + params[:issue_id], notice: "檢舉成功"
        else
            redirect_to "/issuelist/" + params[:issue_id], notice: "檢舉失敗"
        end
    end

    private
    
    def detail_params
        params.require(:data_detail).permit(:is_support, :content, :link, :like_dislike_list_id, :post_id, :people_id, :issue_id, :comment_id, :comment_id, :issue_id,:is_direct,:title_at_that_time,:reported_at, :news_media, :is_report)
    end
    
    def issue_params
        params.require(:data_detail).permit(:datadetail)
    end
end
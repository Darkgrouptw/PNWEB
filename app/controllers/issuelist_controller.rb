class IssuelistController < ApplicationController
	def index
		@tags = params[:issue_id]
		@issues=DataIssue.all.order(:created_at)
		@all_issue = true
		if @issues.where(id: @tags).length >= 1
			@me = @issues.where(id: @tags)[0]
			@strings = @me.datadetail_id.split(/,/)
			@details = DataDetail.where(id: @strings)
            user = []
            person = []
            
            # 要判斷是用什麼來排序
            if params[:orderby] == "Time"
                @detail_supprot = @details.where(is_support: true).order(:created_at).reverse
                @detail_disSupport = @details.where(is_support: false).order(:created_at).reverse
            else
                @detail_supprot = @details.where(is_support: true).order(:count_like).reverse
                @detail_disSupport = @details.where(is_support: false).order(:count_dislike).reverse
            end
            
            i = 0
            @details.each do |detail|
                user.push([detail.post_id])
                person.push([detail.people_id])
                i = i + 1
                if i == 5
                    break
                end
            end
			@users=User.where(id: user)
            @persons=DataPerson.where(id: person)
			@all_issue = false
		else
			@all_issue = true
		end
	end
    
    def pos
		@tags = params[:issue_id]
		@issues=DataIssue.all.order(:created_at)
		@all_issue = true
        
        
		if @issues.where(id: @tags).length >= 1
			@me = @issues.where(id: @tags)[0]
			@strings = @me.datadetail_id.split(/,/)
			@details = DataDetail.where(id: @strings)
            user = []
            person = []
            
            # 要判斷是用什麼來排序
            if params[:orderby] == "Time"
                @detail_supprot = @details.where(is_support: true).order(:created_at).reverse
            else
                @detail_supprot = @details.where(is_support: true).order(:count_like).reverse
            end
            
             @details.each do |detail|
                user.push([detail.post_id])
                person.push([detail.people_id])
            end
			@users=User.where(id: user)
            @persons=DataPerson.where(id: person)
			@all_issue = false
		else
			@all_issue = true
		end
    end
    
    def neg
        @tags = params[:issue_id]
		@issues=DataIssue.all.order(:created_at)
		@all_issue = true
		if @issues.where(id: @tags).length >= 1
			@me = @issues.where(id: @tags)[0]
			@strings = @me.datadetail_id.split(/,/)
			@details = DataDetail.where(id: @strings)
            user = []
            person = []
            
            # 要判斷是用什麼來排序
            if params[:orderby] == "Time"
                @detail_supprot = @details.where(is_support: true).order(:created_at).reverse
                @detail_disSupport = @details.where(is_support: false).order(:created_at).reverse
            else
                @detail_supprot = @details.where(is_support: true).order(:count_like).reverse
                @detail_disSupport = @details.where(is_support: false).order(:count_dislike).reverse
            end
            
            @details.each do |detail|
                user.push([detail.post_id])
                person.push([detail.people_id])
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
        @detail = DataDetail.create(detail_params)
        @detail.issue_id = params[:issue_id]
        @detail.count = 0
        @detail.count_like = 0
        @detail.count_dislike = 0
        require "uri"
        require "net/http"
        require "open-uri"
        
        api = "http://api.page2images.com/directlink?"
        url = @detail.link
        p2i_device = "6"
        p2i_screen="1024x768"
        p2i_size="1024x0"
        p2i_fullpage="1"
        p2i_key="8e549b1ac48187d3"
        src = api+"p2i_url="+url+"&p2i_device="+p2i_device+"&p2i_screen="+p2i_screen+"&p2i_size="+p2i_size+"&p2i_fullpage="+p2i_fullpage+"&p2i_key="+p2i_key;
        open('pageBackUp/'+@detail.issue_id.to_s+@detail.id.to_s+'.png','wb')do |file|
            file << open(src).read
        end
        @detail.link = @detail.issue_id.to_s+@detail.id.to_s
        if current_user == nil
            flash[:alert] = "請先登入!!"
            redirect_to :back
        else
            @detail.post_id = current_user.id
                @detail.comment_id = ""
            if @detail.save
                @tags = params[:issue_id]
                @issue = DataIssue.where(:id => @tags)[0]
                @issue.datadetail_id = @issue.datadetail_id + @detail.id.to_s + ","
                
                @issue.update(issue_params)
                params = {'box1' => 'what??','button1' => 'submit'}
                x = Net::HTTP.post_form(URI.parse(src),params)
                flash[:notice] = "傳送成功"
                redirect_to issuelist_path+"/"+@issue.id.to_s
            else
                render :new
            end
        end
    end
    
    
    private
    
    def detail_params
        params.require(:data_detail).permit(:is_support, :content, :link, :count, :count_like, :count_dislike, :post_id, :people_id, :issue_id, :comment_id, :comment_id, :issue_id)
    end
    
    def issue_params
        params.require(:data_detail).permit(:datadetail)
    end
end
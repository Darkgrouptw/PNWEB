Rails.application.routes.draw do
  get 'pagebackup/index'

    devise_for :users        
    root  "main#index"

    namespace :dataitems do
        resources :data_issues
        resources :data_people
        resources :data_details
    end

    get     "/thread/"                      =>  "main#thread"
    
    get     "/peoplelist"                   =>	"peoplelist#index"
    get     "/peoplelist/:name"             =>	"peoplelist#index"
    get     "/detaillist/"                  =>  "detaillist#index"
    get     "/detaillist/:detail_id"        =>  "detaillist#index"
    get     "/userlist/"                    =>  "userlist#index"
    get     "/userlist/:user_id"            =>  "userlist#index"
    
    
    get     "/issuelist/"                   =>	"issuelist#index"
    get     "/issuelist/:issue_id"          =>	"issuelist#index"
    get     "/issuelist/:issue_id/:positive_page/:negative_page" =>  "issuelist#index"
    post    "/issuelist/:issue_id/Report"   =>  "issuelist#report",     :as => "report_issuelist"
    get     "/issuelist/:issue_id/new"      =>  "issuelist#new",        :as => "new_issuelist"
    post    "/issuelist/:issue_id"          =>  "issuelist#create",     :as => "create_issuelist"
    
    get     "/detaillist/:detail_id/new"    => "detaillist#new",        :as => "new_detallist"
    post    "/detaillist/:detail_id"        => "detaillist#create",     :as => "create_detaillist"
    post    "/detaillist/:detail_id/thumb"  => "detaillist#thumb",      :as => "thumb_detaillist"
    post    "/detaillist/:detail_id/thumb_cancel"   =>  "detaillist#thumb_cancel",  :as => "thumb_cancel_detaillist"
    
    get     "/ReportList"                   => "reportlist#index",      :as => "reportlist"
end

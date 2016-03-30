Rails.application.routes.draw do
    devise_for :users        
    root  "main#index"

    namespace :dataitems do
        resources :data_issues
        resources :data_people
        resources :data_details
        resources :data_comment
    end

    get "/peoplelist"	=>	"peoplelist#index"
    get "/peoplelist/:name"	=>	"peoplelist#index"
    get "/issuelist/"=>	"issuelist#index"
    get "/issuelist/:issue_id"=>	"issuelist#index"
    get "/detaillist/" => "detaillist#index"
    get "/detaillist/:detail_id" => "detaillist#index" 
end

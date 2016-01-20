Rails.application.routes.draw do
  root  "main#index"
  
  #resources :dataitems
  #resources :data_issues
  #resources :data_person
  #get "dataitems"       				=>  "dataitems",     	:as => "dataitems"
  #get "dataitems/add"					=>	"dataitems#add",		:as => "dataitems_add"

  namespace :dataitems do
  	resources :data_issues
  	resources :data_persons
  	resources :data_contents
  	resources :data_pointers
  end
end

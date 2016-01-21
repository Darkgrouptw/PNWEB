Rails.application.routes.draw do
  root  "main#index"

  namespace :dataitems do
  	resources :data_issues
  	resources :data_people
  	resources :data_contents
  	resources :data_pointers
  end
end

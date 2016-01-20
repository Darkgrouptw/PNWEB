Rails.application.routes.draw do
  root  "main#index"
  
  #resources :dataitems
  get "dataitems"       =>  "dataitems#index",     :as => "dataitems"
end

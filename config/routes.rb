Rails.application.routes.draw do
  devise_for :users
  root "groups#index"

  resources :dataitems
  get "Issue/:title"          => "issue#index",         :as => "issue"
  get "PeopleList/:people"    => "peoplelist#index",    :as => "peoplelist"
end

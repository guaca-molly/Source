Rails.application.routes.draw do

  # active admin urls
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # categories controller 
  resources :categories
  
  # items controller
  resources :items

  # a user can sign up multiple times
  resources :users
  # users can only make one session
  resource :session
  # users should only be able to edit one account
  resource :account

  get "about", to: "pages#about"

  root "pages#home"
end

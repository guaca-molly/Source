Rails.application.routes.draw do

  # a user can sign up multiple times
  resources :users
  # users can only make one session
  resource :session

  get "about", to: "pages#about"

  root "pages#home"
end

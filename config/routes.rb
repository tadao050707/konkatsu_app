Rails.application.routes.draw do
  get 'pages/index'
  get 'pages/show'
  devise_for :users
  resources :profiles
  root 'profiles#index'
end

Rails.application.routes.draw do
  get 'relationships/followings'
  get 'relationships/followers'
  get 'pages/index'
  get 'pages/show'
  devise_for :users
  resources :profiles
  root 'profiles#index'
  resources :chats, only: [:show, :create]

  resources :users do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
end

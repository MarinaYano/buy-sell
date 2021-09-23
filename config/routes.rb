Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :items do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create]
  end
  
  root 'items#home'

  devise_for :users
  resources :users, :only => [:index]
  resources :users, only: [:show] 
  resources :messages, :only => [:create, :index]
  resources :rooms, :only => [:create, :show, :index]

  get 'messages/room/:user_id/:to_user_id' => "messages#roomshow"
end

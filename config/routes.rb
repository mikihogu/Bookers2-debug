Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
  end

  # DM機能
  resources :messages, only: [:create, :destroy]
  resources :rooms, only: [:create, :show]

  # グループ
  resources :groups, only: [:index, :show, :new, :create, :edit, :update] do
    get :join, on: :member
    get :leave, on: :member
    get :new_mail, on: :member
    get :send_mail, on: :member
  end


  get "search" => "searches#search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
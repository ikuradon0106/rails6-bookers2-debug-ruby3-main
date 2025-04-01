Rails.application.routes.draw do
  
  get 'relationships/create'
  get 'relationships/destroy'
  devise_for :users

  root :to => "homes#top"
  get "homes/about" => "homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update]
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


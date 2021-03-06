Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:edit, :update]
  root to: 'pages#home'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  post '/profile/edit', to: 'users#update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :investments, only: [:index, :show, :new, :create] do
    resources :bookmarks, only: [:new, :create]
  end

  resources :portfolios, only: [:index, :new, :create, :show, :destroy, :edit, :update ] do
    resources :bookmarks, only: [:index]
  end

  resources :bookmarks, only: [:edit, :update, :destroy]
end

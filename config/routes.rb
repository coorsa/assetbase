Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :investments, only: [:index, :show] do
    resources :bookmarks, only: [:new, :create]
  end

  resources :portfolios, only: [:index, :new, :create, :show, :destroy ] do
    # resources :bookmarks, only: [:index, :show, :edit, :update, :destroy ]
  end
end

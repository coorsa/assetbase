Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :portfolios, only: [:show]
end

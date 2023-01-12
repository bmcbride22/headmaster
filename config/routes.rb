Rails.application.routes.draw do
  devise_for :users
  resources :instruments
  root to: 'pages#landing_page'
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

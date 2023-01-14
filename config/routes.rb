Rails.application.routes.draw do
  devise_for :users
  resources :instruments
  resources :assessments
  resources :cohorts do
    resources :student_profiles, only: %i[new create]
  end
  resources :student_profiles, except: %i[new create]
  resources :syllabuses do
    resources :units, only: %i[new create]
  end
  resources :units, except: %i[new create]

  root to: 'pages#landing_page'
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

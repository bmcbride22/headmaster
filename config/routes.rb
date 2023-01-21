Rails.application.routes.draw do
  devise_for :users
  resources :instruments
  resources :assessments
  resources :cohorts do
    resources :student_profiles, only: %i[new create]
  end
  resources :student_profiles, except: %i[new create]
  resources :syllabuses do
    resources :assessments, only: %i[new create]
    resources :units, only: %i[index new create] do
      resources :assessments, only: %i[new create index destroy]
    end
  end
  resources :units, except: %i[new]
  resources :courses do
    get '/assessment/:assessment_id/grade_assessment',
        to: 'grades#new_assessment_grades', as: 'assessment_grades'
    post '/assessment/:assessment_id/grade_assessment',
         to: 'grades#create_assessment_grades'
  end

  root to: 'pages#landing_page'
  get 'pages/home'
  get 'dashboard', to: 'dashboards#main'
end

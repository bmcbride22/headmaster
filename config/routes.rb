Rails.application.routes.draw do
  devise_for :users
  resources :instruments
  resources :assessments
  resources :cohorts do
    resources :student_profiles, only: %i[new create]
    resources :courses, only: %i[new], to: 'courses#new'
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
    resources :assessment_grades, controller: 'assessment_grades'
  end

  get 'grades/set_course', to: 'grades#set_course'
  get 'grades/course/[:course_id]/new_assessment_grades', to: 'grades#new_assessment_grades',
                                                          as: 'add_assessment_grades'
  get 'grades/course/[:course_id]/assessment/[:assessment_id]/new_assessment_grades', to: 'grades#new_assessment_grades',
                                                                                      as: 'add_grades_to_assessment'
  post 'grades/create_assessment_grades', to: 'grades#create_assessment_grades', as: 'create_assessment_grades'
  get 'grades/course/[:course_id]/assessment/[:assessment_id]/edit_assessment_grades',
      to: 'grades#edit_assessment_grades', as: 'edit_assessment_grades'
  post 'grades/update_assessment_grades', to: 'grades#update_assessment_grades', as: 'update_assessment_grades'
  root to: 'pages#landing_page'

  get 'pages/home'
  get 'dashboard', to: 'dashboards#main'
end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'sessions'
  }
 
  resources :tasks do
    resources :notes, only: [:create], controller: 'tasks/notes'
  end  
    resources :categories

  root "tasks#index"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  #root 'tasks#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

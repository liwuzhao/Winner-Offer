Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }
  root 'welcome#index'

  namespace :admin do
    resources :jobs do
      collection do
        get :search
      end
      member do
        post :publish
        post :hide
      end
    resources :resumes, only: [:index]
    end
  end

  resources :jobs do
    member do
      post :join
      post :quit
    end
    resources :resumes, only: [:index]
    collection do
      get :search
    end
  end

  namespace :account do
    resources :users, only: [:edit, :update]
    resources :jobs, only: [:index]
    resources :jobfs, only: [:index]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

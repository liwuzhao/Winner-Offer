Rails.application.routes.draw do
  devise_for :user, :controllers => { registrations: 'registrations' }
  root 'welcome#index'

  namespace :admin do
    resources :jobs do
      member do
        post :publish
        post :hide
      end
    resources :resumes
    end
  end

  resources :jobs do
    resources :resumes
    collection do
      get :search
    end
  end

  namespace :account do
    resources :users
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

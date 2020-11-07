Rails.application.routes.draw do
  # root to: 'users#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, only: [:index, :show] do
    resources :tasks do
      member do
        patch 'done'
      end
    end

    resources :relationships, only: [:create, :destroy]
    member do
      get 'follows'
      get 'followers'
    end
  end
end

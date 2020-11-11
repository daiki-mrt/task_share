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
  
  resources :rooms, only: [:create, :show]
  resources :messages, only: :create
  
  resources :tasks do
    resources :likes, only: [:create, :destroy]
  end

  resources :communities do
    resources :chats, only: [:index, :create, :destroy]
    resources :questions do
      patch 'resolve', on: :member
    end
  end

  post 'communities/:id', to: 'communities#join'
  delete 'communities/:id/exit', to: 'communities#exit', as: 'exit_community'

  resources :questions do
    resources :answers, only: [:create, :destroy]
  end
end
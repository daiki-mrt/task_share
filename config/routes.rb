Rails.application.routes.draw do
  root to: 'users#index'
  get '/', to: 'users#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
end

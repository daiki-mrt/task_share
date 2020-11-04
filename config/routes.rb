Rails.application.routes.draw do
  get '/', to: 'users#index'
  devise_for :users
end

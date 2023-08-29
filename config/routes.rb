Rails.application.routes.draw do
  devise_for :users
  resources :schedules, only: [:index, :create, :update, :destroy, :new, :show, :edit]
  resources :logs
  root 'home#index'
  get 'home/index'
  post '/save-log', to: 'logs#save_log'
  post '/save-active-window', to: 'logs#save_active_window'
end

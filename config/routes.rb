Rails.application.routes.draw do
  get 'typing_game/index'
  devise_for :users
  resources :schedules, only: [:index, :create, :update, :destroy, :new, :show, :edit]
  resources :logs
  root 'home#index'
  get 'home/index'
  post '/save-log', to: 'logs#save_log'
  post '/save-active-window', to: 'logs#save_active_window'
  get '/typing_game', to: 'typing_game#index'
  get '/words/random_word', to: 'words#random_word'
  get 'products/fetch_and_save', to: 'products#fetch_and_save', as: 'fetch_and_save'
end

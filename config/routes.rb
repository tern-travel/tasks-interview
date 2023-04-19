Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :tasks
  root to: "tasks#index"
end

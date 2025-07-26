Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  namespace :api, defaults: { format: :json } do
    namespace :v1, defaults: { format: :json } do
      resources :users, only: [] do
        resources :transactions, only: [:create]
        resources :rewards,      only: [:index]
      end
    end
  end
end

Rails.application.routes.draw do
  devise_for :users

  # Public landing page for guests
  unauthenticated do
    root to: "pages#home", as: :unauthenticated_root
  end

  # Dashboard for signed‑in users
  authenticated :user do
    root to: "pages#home", as: :authenticated_root
  end

  # Web‑form endpoint to POST a purchase
  resources :transactions, only: [:create]

  # API namespace unchanged…
  namespace :api, defaults: { format: :json } do
    namespace :v1, defaults: { format: :json } do
      resources :users, only: [] do
        resources :transactions, only: [:create]
        resources :rewards,      only: [:index]
      end
    end
  end
end

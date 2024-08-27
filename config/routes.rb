Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :buildings, only: [:index]
      resources :clients do
        resources :buildings, only: [:show, :create, :update, :destroy]
        get 'buildings', to: 'buildings#client_buildings'
      end
    end
  end
end

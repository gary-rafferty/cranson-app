Rails.application.routes.draw do

  resources :plans, only: [:index, :show] do
    collection do
      get :search
      get :within
    end
  end
end

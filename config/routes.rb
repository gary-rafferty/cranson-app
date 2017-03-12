Rails.application.routes.draw do

  resources :plans, only: [:index, :show] do
    collection do
      get :search
      get :within
      get :decided
      get :invalid
      get :unknown
      get :pending
      get :on_appeal
    end
  end
end

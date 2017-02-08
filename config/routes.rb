Rails.application.routes.draw do

  resources :plans, only: [:index, :show] do
    get :search, on: :collection
  end
end

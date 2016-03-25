Rails.application.routes.draw do
  root to: 'interesting_objects#index'
  devise_for :users
  resources :users
  resources :interesting_objects do
    member do
      post 'rate', to: 'interesting_objects#rate'
      post 'estimate_value', to: 'interesting_objects#estimate_value'
    end
  end
end

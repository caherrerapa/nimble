Rails.application.routes.draw do
  resources :keywords do
     collection { post :import }
  end

  root to: "keywords#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  use_doorkeeper do #doorkeeper a good gem to use for authorisation with tokens.
    skip_controllers :authorizations, :applications,
      :authorized_applications
  end

  devise_for :users

  resources :keywords do
     collection { post :import } #to import the csv files of keywords
  end

  namespace :api do
    resources :keywords
  end

  root to: "keywords#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

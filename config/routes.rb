# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/', to: redirect('/api-docs')

  namespace :api do
    namespace :v1 do
      resources :categories do
        resources :recipes, only: :index
      end
      get 'recipes/:id', to: 'recipes#show'
    end
  end
end

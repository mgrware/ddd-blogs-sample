Rails.application.routes.draw do
  mount RailsEventStore::Browser => '/res' if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do 
      resources :articles do
        member do
          put "like/:user_id", to: 'articles#like'
          put "read/:user_id", to: 'articles#read'
          put "comment/:user_id", to: 'articles#comment'
        end
      end
      resources :users
    end 
  end 
end

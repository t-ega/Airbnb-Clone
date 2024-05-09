Rails.application.routes.draw do
  devise_for :users, path: 'auth', path_names: {
    sign_in: '/login',
    sign_out: '/logout',
    registration: '/signup'
  },
  controllers: {
   sessions: 'users/sessions',
   registrations: 'users/registrations'
  }

  resources :home, only: %i[index]
  resources :properties, module: "properties" do
    resources :reservations, only: %i[create, new]
  end

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end

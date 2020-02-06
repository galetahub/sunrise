# frozen_string_literal: true

Sunrise::Engine.routes.draw do
  root Sunrise::Config.root_route_options

  get '/activities/p/:page', to: 'activities#index', page: /\d+/
  get '/dashboard', to: 'dashboard#index', as: :dashboard

  resource :settings, only: [:edit, :update]
  resources :activities, only: [:index]

  controller 'manager' do
    scope ':model_name' do
      get '/', action: :index, as: :index
      get '/export.:format', action: :export, as: :export
      post '/sort', action: :sort, as: :sort
      get '/new', action: :new, as: :new
      post '/new', action: :create, as: :create
      delete '/mass_destroy', action: :mass_destroy, as: :mass_destroy

      scope ':id' do
        get '/', action: :show, as: :show
        get '/edit', action: :edit, as: :edit
        patch '/edit', action: :update, as: :update
        get '/delete', action: :delete, as: :delete
        delete '/delete', action: :destroy, as: :destroy
      end
    end
  end
end

Sunrise::Engine.routes.draw do
  root :to => "dashboard#index"
  
  get "/services", :to => "shared#services", :as => "services"
  get "/dashboard/p/:page", :to => "dashboard#index", :page => /\d+/
  
  resource :settings, :only => [:edit, :update]
  
  controller "manager" do
    scope ":model_name" do
      get "/", :to => :index, :as => "index", :via => [:get, :post]
      get "/export.:format", :to => :export, :as => "export"
      post "/sort", :to => :sort, :as => "sort"
      get "/new", :to => :new, :as => "new"
      post "/new", :to => :create, :as => "create"
      delete "/mass_destroy", :to => :mass_destroy, :as => "mass_destroy"
      
      scope ":id" do
        get "/", :to => :show, :as => "show"
        get "/edit", :to => :edit, :as => "edit"
        patch "/edit", :to => :update, :as => "update"
        get "/delete", :to => :delete, :as => "delete"
        delete "/delete", :to => :destroy, :as => "destroy"
      end
    end
  end
end

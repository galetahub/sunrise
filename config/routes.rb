Sunrise::Engine.routes.draw do
  root :to => "dashboard#index"
  
  match "/services", :to => "shared#services", :as => "services"
  
  controller "manager" do
    scope ":model_name" do
      match "/", :to => :index, :as => "index", :via => [:get, :post]
      match "/export.:format", :to => :export, :as => "export"
      match "/sort", :to => :sort, :as => "sort"
      get "/new", :to => :new, :as => "new"
      post "/new", :to => :create, :as => "create"
      delete "/mass_destroy", :to => :mass_destroy, :as => "mass_destroy"
      
      scope ":id" do
        get "/", :to => :show, :as => "show"
        get "/edit", :to => :edit, :as => "edit"
        put "/edit", :to => :update, :as => "update"
        get "/delete", :to => :delete, :as => "delete"
        delete "/delete", :to => :destroy, :as => "destroy"
      end
    end
  end
end

Sunrise::Engine.routes.draw do
  root :to => "dashboard#index"
  
  controller "manager" do
    scope ":model_name" do
      match "/", :to => :index, :as => "index", :via => [:get, :post]
      match "/export", :to => :export, :as => "export"
      get "/new", :to => :new, :as => "new"
      post "/new", :to => :create, :as => "create"
      post "/bulk_action", :to => :bulk_action, :as => "bulk_action"
      post "/bulk_destroy", :to => :bulk_destroy, :as => "bulk_destroy"
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

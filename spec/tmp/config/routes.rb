Rails.application.routes.draw do
  mount Sunrise::Engine => '/manage'
  
  devise_for :users

  resources :pages, :only => [:show]

  root :to => "welcome#index"
end

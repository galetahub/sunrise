# frozen_string_literal: true

Rails.application.routes.draw do
  mount Sunrise::Engine => '/manage'

  devise_for :users

  resources :pages, only: [:show]
  resources :posts, only: [:index, :show]

  root to: 'welcome#index'
end

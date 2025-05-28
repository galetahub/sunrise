# frozen_string_literal: true

require 'spec_helper'

describe Sunrise::ActivitiesController, type: :controller do
  routes { Sunrise::Engine.routes }
  render_views

  before(:all) do
    @post = FactoryBot.create(:post)
    @user = FactoryBot.create(:redactor_user)
    @event = @post.create_activity key: 'post.create', owner: @user
  end

  describe 'admin' do
    login_admin

    it 'should render index action' do
      get :index
      assigns(:events).should include(@event)
      expect(response).to render_template('index')
    end
  end

  describe 'anonymous user' do
    it 'should not render index action' do
      expect(controller).not_to receive(:index)
      get :index
    end

    it 'should redirect to login page' do
      get :index
      expect(response).to redirect_to '/users/sign_in'
    end
  end
end

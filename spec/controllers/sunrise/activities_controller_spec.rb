# frozen_string_literal: true

require 'spec_helper'

describe Sunrise::ActivitiesController, type: :controller do
  render_views

  before(:all) do
    @post = FactoryGirl.create(:post)
    @user = FactoryGirl.create(:redactor_user)
    @event = @post.create_activity key: 'post.create', owner: @user
  end

  describe 'admin' do
    login_admin

    it 'should render index action' do
      get :index
      assigns(:events).should include(@event)
      response.should render_template('index')
    end
  end

  describe 'anonymous user' do
    it 'should not render index action' do
      controller.should_not_receive(:index)
      get :index
    end

    it 'should redirect to login page' do
      get :index
      response.should redirect_to '/users/sign_in'
    end
  end
end

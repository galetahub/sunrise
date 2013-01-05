require 'spec_helper'

describe Sunrise::DashboardController do
  render_views  
  
  before(:all) do
    @audit = FactoryGirl.create(:audit)
  end
  
  describe "admin" do
    login_admin
    
    it "should render index action" do
      get :index
      assigns(:events).should include(@audit)
      response.should render_template('index')
    end
  end
  
  describe "anonymous user" do
    it "should not render index action" do
      controller.should_not_receive(:index)
      get :index
    end
    
    it "should redirect to login page" do
      get :index
      response.should redirect_to "/users/sign_in"
    end
  end
end

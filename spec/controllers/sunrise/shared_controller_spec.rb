require 'spec_helper'

describe Sunrise::SharedController do
  render_views  
  
  before(:all) do 
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
  end
  
  describe "admin" do
    login_admin
    
    it "should render services action" do
      get :services, :format => :json
      assigns(:services).should include(@page)
      response.should render_template('services')
    end
  end
  
  describe "anonymous user" do
    it "should not render services action" do
      controller.should_not_receive(:services)
      get :services, :format => :json
    end
    
    it "should redirect to login page" do
      get :services
      response.should redirect_to "/users/sign_in"
    end
  end
end

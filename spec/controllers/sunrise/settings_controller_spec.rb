require 'spec_helper'

describe Sunrise::SettingsController do
  render_views  
  
  before(:all) do 
    Settings.some_setting = "value"
    Settings.some_setting2 = "value2"
  end
  
  describe "admin" do
    login_admin
    
    it "should render edit action" do
      get :edit
      assigns(:settings).should_not be_empty
      response.should render_template('edit')
    end
    
    it "should update settings" do
      put :update, :settings => {:some_setting => "blablabla"}
      
      Settings.some_setting.should == "blablabla"
      
      response.should redirect_to(root_path)
    end
  end
  
  describe "anonymous user" do
    it "should not render update action" do
      controller.should_not_receive(:update)
      put :update
    end
    
    it "should not render edit action" do
      controller.should_not_receive(:edit)
      get :edit
    end
    
    it "should redirect to login page" do
      get :edit
      response.should redirect_to "/users/sign_in"
    end
  end
end

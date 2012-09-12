require 'spec_helper'

describe Sunrise::ManagerController do
  #render_views
  
  describe "#current_ability" do
    before(:each) { @ability = controller.send(:current_ability) }
    
    it "should have namespace sunrise" do
      @ability.context.should == :sunrise
    end
    
    it "should be a guest user" do
      @ability.user.should be_new_record
    end
  end
  
  describe "admin" do
    login_admin
    
    context "index" do
      before(:all) do
        @root = FactoryGirl.create(:structure_main)
        @page = FactoryGirl.create(:structure_page, :parent => @root)
      end
      
      it "should respond successfully" do
        get :index, :model_name => "structures"
        
        assigns(:records).should include(@root)
        assigns(:records).should_not include(@page)
        
        response.should render_template('index')
      end
      
      it "should render 404 page" do
        lambda {
          get :index, :model_name => "wrong"
        }.should raise_error ActionController::RoutingError
      end

      it "should not destroy root structure" do
        controller.should_not receive(:destroy)
        delete :destroy, :id => @root.id
      end
    end
  end
end

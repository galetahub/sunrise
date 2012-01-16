require 'spec_helper'

describe "Sunrise Manager Export" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)
    
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
  end

  context "admin" do
    before(:each) do
      login_as @admin
      
      time = Time.parse("01/01/2012 18:00")
      Time.stub!(:now).and_return(time)
    end

    describe "GET /manage/users/export" do
      before(:each) do
        visit export_path(:model_name => "users", :format => :xlsx)
      end
      
      it "should send excel file with users" do
        headers = page.response_headers
        
        
        headers["Content-Transfer-Encoding"].should == "binary"
        headers["Content-Type"].should == "application/vnd.ms-excel"
        headers["Content-Disposition"].should == "attachment; filename=\"users_2012-01-01 16:00:00.xlsx\""
      end
    end
    
    describe "GET /manage/structures/export" do
      before(:each) do
        visit export_path(:model_name => "structures", :format => :xlsx)
      end
      
      it "should send excel file with structures" do
        headers = page.response_headers
        
        headers["Content-Transfer-Encoding"].should == "binary"
        headers["Content-Type"].should == "application/vnd.ms-excel"
        headers["Content-Disposition"].should == "attachment; filename=\"structures_2012-01-01 16:00:00.xlsx\""
      end
    end
  end
  
  describe "anonymous user" do
    before(:each) do
      visit export_path(:model_name => "users", :format => :xlsx)
    end
    
    it "should redirect to login page" do
      should have_content('You need to sign in or sign up before continuing.')
    end
  end
end

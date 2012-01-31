require 'spec_helper'

describe "Sunrise Manager Dashboard" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)    
    @audit = FactoryGirl.create(:audit)
  end

  context "admin" do
    before(:each) { login_as @admin }

    describe "GET /manage" do
      before(:each) do 
        visit root_path
      end
      
      it "should show page title" do
        should have_content "Events"
      end
      
      it "should render records" do
        should have_selector("#audit_#{@audit.id}")
      end
    end
  end
  
  describe "anonymous user" do
    before(:each) do
      visit root_path
    end
    
    it "should redirect to login page" do
      should have_content('Sign in')
    end
  end
end

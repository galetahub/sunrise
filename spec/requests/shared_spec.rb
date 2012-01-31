require 'spec_helper'

describe "Sunrise Manager Shared" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)    
    
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
  end

  context "admin" do
    before(:each) { login_as @admin }

    describe "GET /manage" do
      before(:each) do 
        visit services_path(:format => :json)
      end
      
      it "should show page title" do
        should have_content @page.title
        should have_content "/manage/structures/#{@page.id}/edit"
      end
    end
  end
  
  describe "anonymous user" do
    before(:each) do
      visit services_path(:format => :json)
    end
    
    it "should redirect to login page" do
      should have_content('You need to sign in or sign up before continuing')
    end
  end
end

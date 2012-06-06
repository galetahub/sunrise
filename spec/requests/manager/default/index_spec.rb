require 'spec_helper'

describe "Sunrise Manager Index" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)
    
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
  end

  context "admin" do
    before(:each) { login_as @admin }
    
    describe "GET /manage" do
      it "should respond successfully" do
        visit root_path
      end
    end
    
    describe "GET /manage/typo" do
      it "should raise NotFound" do
        lambda {
          visit '/manage/whatever'
        }.should raise_error ActiveRecord::RecordNotFound
      end
    end

    describe "GET /manage/structures" do
      before(:each) do 
        visit index_path(:model_name => "structures")
      end
      
      it "should show page title" do
        should have_content( @page.title )
      end
    end
    
    describe "GET /manage/users" do
      before(:each) do
        Sunrise::Config.scoped_views = true 
        visit index_path(:model_name => "users")
      end
      
      it "should render inherit user templace" do
        should have_content( "UserTestSection" )
      end
    end
    
    describe "GET /manage/pages" do      
      it "should render 404 page" do
        lambda {
          visit index_path(:model_name => "pages")
        }.should raise_error AbstractController::ActionNotFound
      end
    end
  end
  
  describe "anonymous user" do
    before(:each) do
      visit index_path(:model_name => "structures")
    end
    
    it "should redirect to login page" do
      should have_content('Sign in')
    end
  end
end

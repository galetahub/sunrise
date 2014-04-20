require 'spec_helper'

describe "Sunrise Manager Edit" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)
    
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
  end
  
  context "admin" do
    before(:each) { login_as @admin }

    describe "update" do
      before(:each) do
        visit edit_path(:model_name => "structures", :id => @page.id)
        
        #save_and_open_page
        
        fill_in "structure[title]", :with => "Title updated"
        select(StructureType.posts.title, :from => "structure_structure_type_id")
        select(PositionType.default.title, :from => "structure_position_type_id")
        uncheck('structure[is_visible]')
        
        click_button "submit-button-hidden"
      end
      
      it "should update an object with correct attributes" do
        @page.reload
        
        @page.title.should == "Title updated"
        @page.structure_type.should == StructureType.posts
        @page.position_type.should == PositionType.default
        @page.is_visible.should == false
      end
      
      it "should redirect with model_name" do
        page.current_path.should == "/manage/structures"
      end
    end
    
    describe "Update /manage/pages/:id/edit" do
      before(:each) do
        @page.update_attributes({:content => "Main", :sidebar => "Sidebar"})
        
        visit edit_path(:model_name => "pages", :id => @page.id)
        
        fill_in "structure[content]", :with => "Main updated"
        fill_in "structure[sidebar]", :with => "Sidebar updated"
        
        click_button "submit-button-hidden"
      end
      
      it "should update an object with correct attributes" do
        @page.reload
        
        @page.content.should == "Main updated"
        @page.sidebar.should == "Sidebar updated"
      end
    end
  end
  
  describe "anonymous user" do
    before(:each) do
      visit edit_path(:model_name => "structures", :id => @page.id)
    end
    
    it "should redirect to login page" do
      should have_content('Sign in')
    end
  end
end

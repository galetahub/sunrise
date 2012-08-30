require 'spec_helper'

describe "Sunrise Manager Edit many" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)
    
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
    
    @post = FactoryGirl.create(:post, :structure => @page)
  end
  
  context "admin" do
    before(:each) { login_as @admin }

    describe "update" do
      before(:each) do
        visit edit_path(:model_name => "posts", :id => @post.id, :parent_id => @page.id, :parent_type => @page.class.name)
        
        #save_and_open_page
        
        fill_in "post[title]", :with => "Title updated"
        fill_in "post[content]", :with => "Tra la la"
        uncheck('post[is_visible]')
        
        click_button "submit-button-hidden"
      end
      
      it "should update an object with correct attributes" do
        @post.reload
        
        @post.title.should == "Title updated"
        @post.content.should == "Tra la la"
        @post.structure.should == @page
        @post.is_visible.should == false
      end
      
      it "should redirect with association params" do
        page.current_path.should == "/manage/posts"
        page.current_url.should == "http://www.example.com/manage/posts?parent_id=#{@page.id}&parent_type=#{@page.class.name}"
      end
    end
  end
  
  describe "anonymous user" do
    before(:each) do
      visit edit_path(:model_name => "posts", :id => @post.id, :parent_id => @page.id, :parent_type => @page.class.name)
    end
    
    it "should redirect to login page" do
      should have_content('Sign in')
    end
  end
end

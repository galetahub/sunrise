require 'spec_helper'

describe "Sunrise Manager New" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)
    
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
  end

  context "admin" do
    before(:each) { login_as @admin }

    describe "create" do
      before(:each) do
        visit new_path(:model_name => "posts", :parent_id => @page.id, :parent_type => @page.class.name)
        
        fill_in "post[title]", :with => "Aimbulance"
        fill_in "post[content]", :with => "Some long text" * 10
        check('post[is_visible]')
        
        click_button "Create"
        
        @post = Post.last
      end
      
      it "should create an object with correct attributes" do
        @post.should_not be_nil
        @post.title.should == "Aimbulance"
        @post.content.should_not be_blank
        @post.is_visible.should == true
        @post.structure.should == @page
      end
    end
  end
  
  describe "anonymous user" do
    before(:each) do
      visit new_path(:model_name => "posts")
    end
    
    it "should redirect to login page" do
      should have_content('Sign in')
    end
  end
end

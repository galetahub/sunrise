require 'spec_helper'

describe "Sunrise Manager New many" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)
    
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
  end

  context "admin" do
    before(:each) { login_as @admin }

    describe "GET /manage/posts/new" do
      before(:each) do 
        visit new_path(:model_name => "posts", :parent_id => @page.id, :parent_type => @page.class.name)
      end
      
      it "should show page title" do
        should have_content( I18n.t('manage.add') )
      end
      
      it "should generate field to edit" do
        SunrisePost.config.edit.fields.each do |f|
          if ['content'].include?(f.name)
            should have_selector "textarea[@name='post[#{f.name}]']"
          else        
            should have_selector "input[@name='post[#{f.name}]']"
          end
        end
      end
      
      it "should set parent params" do
        should have_selector "input[@name='parent_id']"
        should have_selector "input[@name='parent_type']"
      end
    end
  end
end

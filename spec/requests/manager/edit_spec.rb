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
    
    describe "GET /manage/typo/edit" do
      it "should raise NotFound" do
        lambda {
          visit edit_path(:model_name => "whatever", :id => @page.id)
        }.should raise_error ActiveRecord::RecordNotFound
      end
    end

    describe "GET /manage/structures/:id/edit" do
      before(:each) do
        visit edit_path(:model_name => "structures", :id => @page.id)
      end
      
      it "should show page title" do
        should have_content( I18n.t('manage.edit') )
      end
      
      it "should generate field to edit" do
        SunriseStructure.config.edit.fields.each do |f|
          should have_selector "input[@name='structure[#{f.name}]']"
        end
      end
    end
    
    describe "GET /manage/pages/:id/edit" do
      before(:each) do
        @root = FactoryGirl.create(:structure_main)
        visit new_path(:model_name => "pages", :id => @root.id)
      end
      
      it "should show page title" do
        should have_content( I18n.t('manage.edit') )
      end
      
      it "should generate field to edit" do
        SunrisePage.config.edit.fields.each do |f|
          should have_selector "input[@name='page[#{f.name}]']"
        end
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

require 'spec_helper'

describe "Sunrise Manager New" do
  subject { page }
  before(:all) { login_as FactoryGirl.create(:admin_user) }

  describe "GET /manage/structures/new" do
    before(:each) do 
      visit new_path(:model_name => "structures")
    end
    
    it "should show page title" do
      should have_content( I18n.t('manage.add') )
    end
  end
end

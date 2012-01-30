require 'spec_helper'

describe Sunrise do
  it "should be valid" do
    Sunrise.should be_a(Module)
  end
  
  it "should return valid root path" do
    File.exists?( Sunrise.root_path ).should be_true
  end
  
  context "configuration" do
    before(:each) do
      Sunrise.setup do |c|
        c.default_items_per_page = 50
        c.default_sort_mode = :asc
        c.default_list_view = 'table'
        c.scoped_views = true
      end
    end
    
    it "should store configuration" do
      Sunrise::Config.default_items_per_page.should == 50
      Sunrise::Config.default_sort_mode.should == :asc
      Sunrise::Config.default_list_view.should == 'table'
      Sunrise::Config.scoped_views.should == true
    end
  end
end

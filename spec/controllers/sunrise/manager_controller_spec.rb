require 'spec_helper'

describe Sunrise::ManagerController do
  describe "#current_ability" do
    before(:each) { @ability = controller.send(:current_ability) }
    
    it "should have namespace sunrise" do
      @ability.context.should == :sunrise
    end
    
    it "should be a guest user" do
      @ability.user.should be_new_record
    end
  end
end

# encoding: utf-8
require 'spec_helper'

describe I18n do
  before(:each) do
    @date = Date.parse("2012-06-26")
  end  
  
  context "uk" do
    before(:each) do
      I18n.locale = :uk
    end
    
    it "should localize month name" do
      I18n.l(@date, :format => "%d.%m.%Y").should == "26.06.2012"
      I18n.l(@date, :format => "%d %B %Y").should == "26 червня 2012"
    end
  end
  
  context "ru" do
    before(:each) do
      I18n.locale = :ru
    end
    
    it "should localize month name" do
      I18n.l(@date, :format => "%d.%m.%Y").should == "26.06.2012"
      I18n.l(@date, :format => "%d %B %Y").should == "26 июня 2012"
    end
  end
end

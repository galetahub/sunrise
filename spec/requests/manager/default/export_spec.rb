require 'spec_helper'

describe "Sunrise Manager Export" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)
    
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
  end

  context "admin" do
    before(:each) do
      login_as @admin
      
      time = Time.parse("01/01/2012 18:00")
      Time.stub!(:now).and_return(time)
    end

    describe "GET /manage/users/export.xlsx" do
      before(:each) do
        visit export_path(:model_name => "users", :format => :xlsx)
      end
      
      it "should send excel file with users" do
        headers = page.response_headers
        
        headers["Content-Transfer-Encoding"].should == "binary"
        headers["Content-Type"].should == "application/vnd.ms-excel"
        headers["Content-Disposition"].should == "attachment; filename=\"users_2012-01-01_16h00m00.xls\""
      end
    end
    
    describe "GET /manage/users/export.csv" do
      before(:each) do
        visit export_path(:model_name => "users", :format => :csv)
      end
      
      it "should send csv file with users" do
        headers = page.response_headers
        
        headers["Content-Transfer-Encoding"].should == "binary"
        headers["Content-Type"].should == "text/csv"
        headers["Content-Disposition"].should == "attachment; filename=\"users_2012-01-01_16h00m00.csv\""
        
        page.status_code.should == 200
        page.body.should_not be_blank
        page.body.should include(@admin.email)
      end
    end
    
    describe "GET /manage/users/export.json" do
      before(:each) do
        visit export_path(:model_name => "users", :format => :json)
      end
      
      it "should render users to json format" do
        page.body.should include(@admin.email)
        
        page.response_headers["Content-Type"].should == "application/json; charset=utf-8"
      end
    end
    
    describe "GET /manage/posts/export.csv" do
      before(:each) do
        @page.posts.create(:title => "Some title")
        
        visit export_path(:model_name => "posts", :format => :csv)
      end
      
      it "should send csv file with posts" do
        headers = page.response_headers
        
        headers["Content-Transfer-Encoding"].should == "binary"
        headers["Content-Type"].should == "text/csv"
        headers["Content-Disposition"].should == "attachment; filename=\"posts_2012-01-01_16h00m00.csv\""
        
        page.status_code.should == 200
        page.body.should_not be_blank
        page.body.should include(@page.title)
        page.body.should include(@page.slug)
      end
    end
    
    describe "GET /manage/structures/export.xlsx" do
      before(:each) do
        visit export_path(:model_name => "structures", :format => :xlsx)
      end
      
      it "should send excel file with structures" do
        headers = page.response_headers
        
        headers["Content-Transfer-Encoding"].should == "binary"
        headers["Content-Type"].should == "application/vnd.ms-excel"
        headers["Content-Disposition"].should == "attachment; filename=\"structures_2012-01-01_16h00m00.xls\""
      end
    end
    
    describe "GET /manage/structures/export.xml" do
      before(:each) do
        visit export_path(:model_name => "structures", :format => :xml)
      end
      
      it "should render structures to xml format" do
        page.body.should include(@root.title)
        
        page.response_headers["Content-Type"].should == "application/xml; charset=utf-8"
      end
    end
  end
  
  describe "anonymous user" do
    before(:each) do
      visit export_path(:model_name => "users", :format => :xlsx)
    end
    
    it "should redirect to login page" do
      should have_content('You need to sign in or sign up before continuing.')
    end
  end
end

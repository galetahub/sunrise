require 'spec_helper'
require "generators/sunrise/install_generator"
require 'fileutils'

describe Sunrise::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)
#  arguments %w(something)

  before(:all) do
    prepare_destination
    
    dir = File.expand_path("../../", __FILE__)
    FileUtils.mkdir_p(File.join(dir, "tmp/config"))
    FileUtils.copy_file(File.join(dir, "dummy/config/routes.rb"), File.join(dir, "tmp/config", "routes.rb"))
    FileUtils.copy_file(File.join(dir, "dummy/config/application.rb"), File.join(dir, "tmp/config", "application.rb"))
    
    run_generator
  end
  
  it "should copy_stylesheets" do
    assert_file "app/assets/stylesheets/alert.css"
  end
  
  it "should copy_views" do
    assert_directory "app/views/pages"
    assert_directory "app/views/shared"
    assert_file "app/views/pages/show.html.erb"
    assert_file "app/views/shared/_notice.html.erb"
  end
  
  it "should copy_configurations" do
    ["db/seeds.rb", "config/initializers/sunrise.rb", "config/application.yml.sample", "config/database.yml.sample",
     "config/logrotate-config.sample", "config/nginx-config-passenger.sample"].each do |file|
      assert_file file
    end
  end
  
  it "should copy_models" do
    assert_directory "app/models/defaults"
    assert_directory "app/models/sunrise"
    assert_directory "app/uploaders"
  end

  it "should copy_specs" do
    assert_directory "spec"
    assert_file "spec/spec_helper.rb"
    assert_file ".rspec"
  end
end

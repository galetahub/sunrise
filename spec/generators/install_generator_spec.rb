# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/sunrise/install_generator'
require 'fileutils'

describe Sunrise::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __dir__)
  #  arguments %w(something)

  before(:all) do
    prepare_destination

    dir = File.expand_path('..', __dir__)
    FileUtils.mkdir_p(File.join(dir, 'tmp/config'))
    FileUtils.copy_file(File.join(dir, 'dummy/config/routes.rb'), File.join(dir, 'tmp/config', 'routes.rb'))
    FileUtils.copy_file(File.join(dir, 'dummy/config/application.rb'), File.join(dir, 'tmp/config', 'application.rb'))

    run_generator
  end

  it 'should copy_views' do
    assert_directory 'app/views/pages'
    assert_directory 'app/views/shared'
    assert_file 'app/views/pages/show.html.erb'
    assert_file 'app/views/shared/_notice.html.erb'
  end

  it 'should copy_configurations' do
    ['db/seeds.rb', 'config/initializers/sunrise.rb', 'config/database.yml.sample',
     'config/logrotate-config.sample', 'config/nginx-unicorn.sample', 'config/nginx-passenger.sample'].each do |file|
      assert_file file
    end
  end

  it 'should copy_models' do
    assert_directory 'app/models/defaults'
    assert_directory 'app/sunrise'
    assert_directory 'app/uploaders'
  end

  it 'should copy_specs' do
    assert_directory 'spec'
    assert_file 'spec/spec_helper.rb'
    assert_file '.rspec'
  end

  it 'should copy gitignore' do
    assert_file '.gitignore'
  end

  it 'should copy assets files' do
    assert_file 'app/assets/javascripts/sunrise/plugins.js'
    assert_file 'app/assets/stylesheets/sunrise/plugins.css'
  end
end

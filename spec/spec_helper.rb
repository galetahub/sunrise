# frozen_string_literal: true

# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
SUNRISE_ORM = (ENV['SUNRISE_ORM'] || :active_record).to_sym

puts "\n==> Sunrise.orm = #{SUNRISE_ORM.inspect}. SUNRISE_ORM = (active_record|mongoid)"

require 'fileutils'
FileUtils.rm_rf(File.expand_path('tmp', __dir__))

require "orm/kaminari/#{SUNRISE_ORM}"

require File.expand_path('dummy/config/environment.rb', __dir__)
require "orm/#{SUNRISE_ORM}"
require "page_parts/orm/#{SUNRISE_ORM}"
require "meta_manager/orm/#{SUNRISE_ORM}"

require 'rails/test_help'
require 'rspec/rails'
require 'generator_spec/test_case'
require 'capybara/rspec'
require 'database_cleaner'

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = 'test.com'

Rails.backtrace_cleaner.remove_silencers!

require 'carrierwave'
require 'carrierwave/orm/activerecord' if SUNRISE_ORM == :active_record

CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end

# use different dirs when testing
CarrierWave::Uploader::Base.descendants.each do |klass|
  next if klass.anonymous?

  klass.class_eval do
    def cache_dir
      "#{Rails.root}/spec/support/uploads/tmp"
    end

    def store_dir
      "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end

# Fixtures replacement with a straightforward definition syntax
require 'factory_girl'
FactoryGirl.definition_file_paths = [File.expand_path('factories', __dir__)]
FactoryGirl.find_definitions

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers
  config.include Sunrise::Engine.routes.url_helpers
  config.include Warden::Test::Helpers
  config.include Capybara::DSL

  # == Mock Framework
  config.mock_with :rspec

  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelper, type: :controller
  config.extend ControllerMacros, type: :controller

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.before(:all) do
    DatabaseCleaner.clean
  end

  config.after(:each) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
  end

  config.after(:all) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end
end

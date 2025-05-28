# frozen_string_literal: true

# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'

unless defined?(SUNRISE_ORM)
  SUNRISE_ORM = (ENV['SUNRISE_ORM'] || :active_record).to_sym
end

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
require 'capybara/rspec'
require 'database_cleaner'
require 'factory_bot_rails'

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

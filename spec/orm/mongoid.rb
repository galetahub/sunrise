require "mongoid"
require "database_cleaner"
require "public_activity"

DatabaseCleaner[:mongoid].strategy = :truncation

PublicActivity::Config.set do
  orm :mongoid
end

# Hook for rspec-rails
module ActiveRecord
  module TestFixtures
  end
end
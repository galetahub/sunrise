# frozen_string_literal: true

source 'https://rubygems.org'

# Declare your gem's dependencies in sunrise-cms.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'rails', '~> 4.2', '>= 4.2.11.1'

# jquery-rails is used by the dummy application
gem 'jquery-rails'

gem 'devise'
gem 'devise-encryptable'
gem 'ruby2xlsx'

gem 'galetahub-enum_field', '~> 0.4.0'
gem 'rails-settings-cached', '~> 0.4.0'
gem 'rails-uploader', '~> 0.3.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'

  gem 'libv8', '~> 3.11.8.4', platforms: :ruby
  gem 'therubyracer', platforms: :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'fuubar'
  gem 'generator_spec', '~> 0.9.4'
  gem 'launchy'
  gem 'ruby-progressbar'
end

group :active_record do
  gem 'activerecord'
  gem 'awesome_nested_set'
  gem 'pg', '~> 0.15'
end

# group :mongoid do
#   gem 'bson_ext'
#   gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
#   gem 'mongoid', '~> 4.0.2'
#   gem 'mongoid_nested_set', '>= 0.2.1'
# end

# frozen_string_literal: true

source 'https://rubygems.org'

# Declare your gem's dependencies in sunrise-cms.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'rails', '~> 7.0'

gem 'devise'
gem 'devise-encryptable'

gem 'galetahub-enum_field'
gem 'rails-settings-cached'
gem 'rails-uploader'

gem 'sprockets'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'sass'

  gem 'uglifier'
end

group :development, :test do
  gem 'generator_spec'
  gem 'launchy'
  gem 'rails-controller-testing'
end

group :active_record do
  gem 'activerecord'
  gem 'awesome_nested_set'
  gem 'pg'
end

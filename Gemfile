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

gem 'sprockets', '>= 3.0.0', '< 4.0.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'sass'

  gem 'libv8', '~> 3.11.8.4', platforms: :ruby
  gem 'uglifier', '>= 1.0.3'
  # gem 'therubyracer', platforms: :ruby
end

group :development, :test do
  gem 'byebug'
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

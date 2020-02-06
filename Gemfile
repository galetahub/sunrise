# frozen_string_literal: true

source 'http://rubygems.org'

# Declare your gem's dependencies in sunrise-cms.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem 'babosa'
gem 'cancan'
gem 'cancan_namespace'
gem 'carrierwave'
gem 'devise'
gem 'devise-encryptable'
gem 'galetahub-enum_field', require: 'enum_field'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'meta_manager', '~> 0.2.0'
gem 'mime-types'
gem 'mini_magick'
gem 'page_parts', '~> 0.1.3'
gem 'progressbar'
gem 'public_activity', '>= 1.0.0'
gem 'rails-uploader'
gem 'ruby2xlsx', '~> 0.0.1'
gem 'select2-rails'
gem 'simple_form'

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
  gem 'launchy'
  gem 'ruby-progressbar'
end

group :active_record do
  gem 'activerecord'
  gem 'awesome_nested_set'
end

group :mongoid do
  # gem "mongoid", ">= 3.1.0"
  gem 'bson_ext'
  gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
  gem 'mongoid', '~> 4.0.0.beta1'
  gem 'mongoid_nested_set', git: 'git://github.com/thinkwell/mongoid_nested_set.git'
end

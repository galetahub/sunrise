source "http://rubygems.org"

# Declare your gem's dependencies in sunrise-cms.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails", "~> 2.0.0"
gem 'devise'
gem "devise-encryptable", "~> 0.1.1"
gem "mini_magick"
gem "ruby2xlsx", "~> 0.0.1"
gem "galetahub-enum_field", :require => "enum_field"
gem "rails-uploader"
gem "cancan"
gem "cancan_namespace"
gem "carrierwave"
gem "mini_magick"
gem "mime-types"
gem "kaminari"
gem "simple_form"
gem "jbuilder"
gem "progressbar"
gem "babosa"
gem "page_parts", "~> 0.1.2"
gem "meta_manager", "~> 0.1.1"
gem "strong_parameters"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  
  gem "libv8", "~> 3.11.8.4", :platforms => :ruby
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem "fuubar"
  gem "launchy"
  gem "ruby-progressbar"
end

group :active_record do
  gem "activerecord"
  gem "audited-activerecord"
  gem "awesome_nested_set"
end

group :mongoid do
  gem "mongoid"
  gem "bson_ext"
  gem "carrierwave-mongoid", :require => "carrierwave/mongoid"
  gem "mongoid_nested_set", :git => "git://github.com/thinkwell/mongoid_nested_set.git"
  gem "mongoid-history"
end


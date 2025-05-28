# frozen_string_literal: true

unless defined?(SUNRISE_ORM)
  SUNRISE_ORM = (ENV["SUNRISE_ORM"] || :active_record).to_sym
end

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../../Gemfile', __FILE__)
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

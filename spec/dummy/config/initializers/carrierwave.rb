# frozen_string_literal: true

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

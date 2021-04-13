# frozen_string_literal: true

require 'rails'
require 'sunrise'
require 'select2-rails'
require 'jquery-ui-rails'

module Sunrise
  class Engine < ::Rails::Engine
    engine_name 'sunrise'
    isolate_namespace Sunrise

    config.i18n.load_path += Dir[Sunrise.root_path.join('config/locales/**', '*.{rb,yml}')]

    config.assets.precompile += %w[
      sunrise/*
    ]

    initializer 'sunrise.setup' do
      I18n::Backend::Simple.include I18n::Backend::Pluralization
      I18n::Backend::Simple.include I18n::Backend::Transliterator

      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.include Sunrise::CarrierWave::Glue
      end

      ActiveSupport.on_load :action_view do
        ActionView::Base.include Sunrise::Views::Helper
      end

      Mongoid::Criteria.include Sunrise::Hooks::Adapters::Mongoid if defined?(Mongoid::Document)
    end

    initializer 'sunrise.csv_renderer' do
      ::ActionController::Renderers.add :csv do |collection, options|
        doc = Sunrise::Utils::CsvDocument.new(collection, options)
        send_data(doc.render, filename: doc.filename, type: Mime::CSV, disposition: 'attachment')
      end
    end
  end
end

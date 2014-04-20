require 'rails'
require 'sunrise'

module Sunrise
  class Engine < ::Rails::Engine
    engine_name "sunrise"
    isolate_namespace Sunrise
    
    config.i18n.load_path += Dir[Sunrise.root_path.join('config/locales/**', '*.{rb,yml}')]
    
    initializer "sunrise.setup" do
      I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
      I18n::Backend::Simple.send(:include, I18n::Backend::Transliterator)
      
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, Sunrise::CarrierWave::Glue
      end
      
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, Sunrise::Views::Helper
      end

      if defined?(Mongoid::Document)
        Mongoid::Criteria.send :include, Sunrise::Hooks::Adapters::Mongoid
      end
    end
    
    initializer "sunrise.csv_renderer" do
      ::ActionController::Renderers.add :csv do |collection, options|
        doc = Sunrise::Utils::CsvDocument.new(collection, options)
        send_data(doc.render, :filename => doc.filename, :type => Mime::CSV, :disposition => "attachment")
      end
    end
  end
end

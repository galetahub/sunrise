require 'rails'
require 'kaminari'
require 'simple_form'
require 'awesome_nested_set'
require 'carrierwave'
require 'enum_field'
require 'friendly_id'
require 'cancan'
require 'cancan_namespace'
require 'acts_as_audited'
require 'page_parts'
require 'meta_manager'

require 'sunrise-cms'
require 'sunrise-file-upload'

module Sunrise
  class Engine < ::Rails::Engine
    engine_name "sunrise"
    isolate_namespace Sunrise
    
    config.i18n.load_path += Dir[Sunrise.root_path.join('config/locales/**', '*.{rb,yml}')]
    
    initializer "sunrise.setup" do
      I18n.backend = Sunrise::Utils::I18nBackend.new
      
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, Sunrise::CarrierWave::Glue
        ActiveRecord::Base.send :include, Sunrise::Utils::Mysql
      end
      
      FriendlyId.send :include, Sunrise::Hooks::FriendlyId
    end
    
    initializer "sunrise.awesome_nested_set" do
      CollectiveIdea::Acts::NestedSet::Model.send :include, Sunrise::NestedSet::Depth
      CollectiveIdea::Acts::NestedSet::Model::InstanceMethods.send :include, Sunrise::NestedSet::Descendants
    end
    
    initializer "sunrise.acts_as_audited" do
      ::Audit.send :include, Sunrise::Hooks::Kaminari
    end
    
    initializer "sunrise.csv_renderer" do
      ::ActionController::Renderers.add :csv do |collection, options|
        doc = Sunrise::Utils::CsvDocument.new(collection, options)
        send_data(doc.render, :filename => doc.filename, :type => Mime::CSV, :disposition => "attachment")
      end
    end
  end
end

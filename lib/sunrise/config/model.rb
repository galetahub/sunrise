require 'active_support/core_ext/string/inflections'
require 'sunrise/config/base'
require 'sunrise/config/index'
require 'sunrise/config/export'
require 'sunrise/config/form'
require 'sunrise/config/show'
require 'sunrise/config/association'

module Sunrise
  module Config
    class Model < Base
      attr_reader :sections
      
      def initialize(abstract_model, parent = nil, options = nil)
        super
        @sections ||= {}
      end
      
      register_instance_option(:label) do
        (@label ||= {})[::I18n.locale] ||= abstract_model.model.model_name.human(:default => abstract_model.model.model_name.to_s.underscore.humanize)
      end
      
      # The display for a model instance (i.e. a single database record).
      # Unless configured in a model config block, it'll try to use :name followed by :title methods, then
      # any methods that may have been added to the label_methods array via Configuration.
      # Failing all of these, it'll return the class name followed by the model's id.
      register_instance_option(:object_label_method) do
        @object_label_method ||= Config.label_methods.find { |method| (@dummy_object ||= abstract_model.model.new).respond_to? method } || :sunrise_default_object_label_method
      end
      
      register_instance_option(:default_index_view) do
        Config.default_index_view
      end
      
      register_instance_option(:available_index_views) do
        Config.available_index_views
      end
      
      register_instance_option(:sort_column) do
        Config.sort_column
      end
      
      def associations
        @associations ||= @sections.select { |key, value| key.to_s.include?('association_') }.values
      end
      
      # Register accessors for all the sections in this namespace
      [:index, :show, :export, :form, :association].each do |section|
        klass = "Sunrise::Config::#{section.to_s.classify}".constantize
        
        define_method(section) do |*args, &block|
          options = args.extract_options!
          name = args.first
          key = name ? [section, name].compact.map(&:to_s).join('_').to_sym : section
          
          options[:name] ||= name
          
          if name === false || @sections[key] === false
            @sections[key] = false
          elsif block
            @sections[key] = PagePresenter.new(options, &block)
          elsif @sections[key].is_a?(PagePresenter)
            presenter = @sections[key]

            instance = klass.new(abstract_model, self, presenter.options)
            instance.instance_exec &presenter.block

            @sections[key] = instance
          else
            @sections[key] ||= klass.new(abstract_model, self, options)
          end
          
          @sections[key]
        end
      end
    end
  end
end

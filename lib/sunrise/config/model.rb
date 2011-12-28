require 'active_support/core_ext/string/inflections'
require 'sunrise/config/base'
require 'sunrise/config/list'
require 'sunrise/config/edit'
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
        (@label ||= {})[::I18n.locale] ||= abstract_model.model.model_name.human(:default => abstract_model.model.model_name.demodulize.underscore.humanize)
      end
      
      # The display for a model instance (i.e. a single database record).
      # Unless configured in a model config block, it'll try to use :name followed by :title methods, then
      # any methods that may have been added to the label_methods array via Configuration.
      # Failing all of these, it'll return the class name followed by the model's id.
      register_instance_option(:object_label_method) do
        @object_label_method ||= Config.label_methods.find { |method| (@dummy_object ||= abstract_model.model.new).respond_to? method } || :sunrise_default_object_label_method
      end
      
      register_instance_option(:default_list_view) do
        Config.default_list_view
      end
      
      def associations
        @associations ||= @sections.select { |key, valur| key.to_s.include?('association_') }.values
      end
      
      # Register accessors for all the sections in this namespace
      [:list, :edit, :association].each do |name|
        section = "Sunrise::Config::#{name.to_s.classify}".constantize
        name = name.to_s.downcase.to_sym
        send(:define_method, name) do |*args, &block|
          options = args.extract_options!
          key = [name, args.first].compact.join('_').to_sym
          options[:name] ||= args.first
          
          @sections[key] ||= section.new(abstract_model, self, options)
          @sections[key].instance_eval &block if block
          @sections[key]
        end
      end
    end
  end
end

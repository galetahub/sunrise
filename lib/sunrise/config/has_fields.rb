require 'sunrise/config/field'
require 'sunrise/config/nested_field'

module Sunrise
  module Config
    # Provides accessors and autoregistering of model's fields.
    module HasFields
    
      # Array for store all defined fields
      def fields
        @fields ||= []
      end
      
      # Defines a configuration for a field.
      def field(name = :custom, options = {}, &block)
        options = { :name => name.to_sym }.merge(options)
        fields << Field.new(abstract_model, self, options, &block)
      end

      # Defines a configuration for a nested attributes
      def nested_attributes(name, options = {}, &block)
        options = { :name => name.to_sym }.merge(options)
        nested_field = NestedField.new(abstract_model, self, options)
        nested_field.instance_eval &block if block
        fields << nested_field
      end
    end
  end
end   

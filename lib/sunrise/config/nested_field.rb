require 'sunrise/config/field'

module Sunrise
  module Config
    class NestedField < Field

      # Array for store all defined fields
      def fields
        @fields ||= []
      end
      
      # Defines a configuration for a field.
      def field(name, options = {})
        options = { :name => name.to_sym }.merge(options)
        fields << Field.new(abstract_model, self, options)
      end

      def nested?
        true
      end

      def multiply?
        @config_options[:multiply] != false
      end
    end
  end
end
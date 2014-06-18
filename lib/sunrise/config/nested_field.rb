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

      def sort?
        @config_options[:sort] != false
      end

      def sort_hidden_field?
        sort? && sort_options[:hidden_field]
      end

      def sort_column
        sort_options[:column]
      end

      def sort_options
        @sort_options ||= build_sort_options
      end

      protected

        def build_sort_options
          options = (@config_options[:sort].is_a?(Hash) ? @config_options[:sort] : {}).symbolize_keys
          
          {
            :column => :sort_order, 
            :hidden_field => true
          }.merge(options)
        end
    end
  end
end
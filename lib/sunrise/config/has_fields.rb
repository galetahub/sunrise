require 'sunrise/config/field'

module Sunrise
  module Config
    # Provides accessors and autoregistering of model's fields.
    module HasFields
    
      # Array for store all defined fields
      def fields
        @fields ||= []
      end
      
      # Defines a configuration for a field.
      def field(name, options = {})
        options = { :name => name.to_sym }.merge(options)
        fields << Field.new(abstract_model, self, options)
      end
    end
  end
end   

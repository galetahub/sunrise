module Sunrise
  module Config
    # Provides accessors and autoregistering of model's fields.
    module HasFields
      attr_reader :fields
      
      # Defines a configuration for a field.
      def field(name, type = nil, options = {})
        @fields ||= []
        @fields << name
      end
    end
  end
end   

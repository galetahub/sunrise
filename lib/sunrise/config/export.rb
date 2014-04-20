require 'sunrise/config/base'
require 'sunrise/config/has_groups'
require 'sunrise/config/has_fields'

module Sunrise
  module Config
    class Export < Base
      include Sunrise::Config::HasFields
      
      # Column to sort
      register_instance_option :sort_column do
        abstract_model.model.primary_key
      end
      
      # Sort direction
      register_instance_option :sort_mode do
        Sunrise::Config.default_sort_mode
      end
      
      # Default scope
      register_instance_option(:scope) do
        nil
      end
    end
  end
end

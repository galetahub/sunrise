require 'sunrise/config/base'
require 'sunrise/config/has_groups'
require 'sunrise/config/has_fields'

module Sunrise
  module Config
    class List < Base
      include Sunrise::Config::HasFields
      include Sunrise::Config::HasGroups
        
      # Number of items listed per page
      register_instance_option :items_per_page do
        Sunrise::Config.default_items_per_page
      end

      register_instance_option :sort_by do
        abstract_model.model.primary_key
      end

      register_instance_option :sort_reverse? do
        Sunrise::Config.default_sort_reverse
      end
    end
  end
end

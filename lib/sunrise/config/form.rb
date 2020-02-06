# frozen_string_literal: true

require 'sunrise/config/base'
require 'sunrise/config/has_fields'

module Sunrise
  module Config
    class Form < Base
      include Sunrise::Config::HasFields
      include Sunrise::Config::HasGroups

      # List of permissible attributes
      register_instance_option :permited_attributes do
        :all
      end
    end
  end
end

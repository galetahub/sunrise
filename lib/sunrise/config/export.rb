require 'sunrise/config/base'
require 'sunrise/config/has_fields'

module Sunrise
  module Config
    class Export < Base
      include Sunrise::Config::HasFields
      
      register_instance_option(:scope) do
        nil
      end
    end
  end
end

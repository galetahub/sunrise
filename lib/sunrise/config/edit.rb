require 'sunrise/config/base'
require 'sunrise/config/has_fields'

module Sunrise
  module Config
    class Edit < Base
      include Sunrise::Config::HasFields
      include Sunrise::Config::HasGroups
    end
  end
end

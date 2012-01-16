require 'sunrise/config/base'
require 'sunrise/config/has_fields'

module Sunrise
  module Config
    class Export < Base
      include Sunrise::Config::HasFields
    end
  end
end

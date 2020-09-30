# frozen_string_literal: true

require 'sunrise/config/base'
require 'sunrise/config/has_fields'

module Sunrise
  module Config
    class Show < Base
      include Sunrise::Config::HasFields
    end
  end
end

require 'sunrise/config/base'
require 'sunrise/config/has_fields'

module Sunrise
  module Config
    class Group < Base
      include Sunrise::Config::HasFields
      
      attr_reader :name

      def initialize(abstract_model, parent, name = :default)
        super(abstract_model, parent)
        @name = name.to_s.tr(' ', '_').downcase.to_sym
      end
    end
  end
end

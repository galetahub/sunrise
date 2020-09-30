# frozen_string_literal: true

module Sunrise
  module Models
    class PositionType
      include EnumField::DefineEnum

      attr_reader :code

      def initialize(code)
        @code = code.to_sym
      end

      def title
        I18n.t(@code, scope: [:manage, :structure, :position])
      end
    end
  end
end

# frozen_string_literal: true

module Sunrise
  module Models
    class StructureType
      include EnumField::DefineEnum

      attr_reader :kind

      def initialize(value)
        @kind = value.to_sym
      end

      def title
        I18n.t(@kind, scope: [:manage, :structure, :kind])
      end
    end
  end
end

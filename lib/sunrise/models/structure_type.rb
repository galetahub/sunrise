# frozen_string_literal: true

module Sunrise
  module Models
    class StructureType
      include EnumField::DefineEnum

      def title
        I18n.t(name, scope: 'manage.structure.kind')
      end
    end
  end
end

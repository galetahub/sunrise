# frozen_string_literal: true

module Sunrise
  module Models
    class PositionType
      include EnumField::DefineEnum

      def title
        I18n.t(name, scope: 'manage.structure.position')
      end
    end
  end
end

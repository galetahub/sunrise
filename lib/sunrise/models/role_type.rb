# frozen_string_literal: true

module Sunrise
  module Models
    class RoleType
      include EnumField::DefineEnum

      def title
        I18n.t(name, scope: 'manage.role.kind')
      end

      def self.legal?(value)
        all.map(&:id).include?(value)
      end
    end
  end
end

# frozen_string_literal: true

require 'csv'
require 'enum_field'

module Sunrise
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        extend EnumField::EnumeratedAttribute

        enumerated_attribute :role_type

        has_one :avatar, as: :assetable, dependent: :destroy, autosave: true

        after_initialize :set_default_role

        validates :name, presence: true
        validate :check_role

        scope :with_email, ->(email) { where(email: email) }
        scope :with_name, ->(name) { where(name: name) }
        scope :with_role, ->(role_type) { where(role_type_id: role_type.id) }
        scope :defaults, -> { with_role(::RoleType.default) }
        scope :moderators, -> { with_role(::RoleType.moderator) }
        scope :admins, -> { with_role(::RoleType.admin) }
      end

      module ClassMethods
        def to_csv(options = {})
          options = { columns: [:id, :email, :name, :current_sign_in_ip] }.merge(options)
          query = unscoped.order([:id, :desc]).select(options[:columns])

          ::CSV.generate do |csv|
            csv << options[:columns]

            query.find_each do |user|
              csv << options[:columns].inject([]) do |items, attr_name|
                items << user.send(attr_name)
              end
            end
          end
        end
      end

      def default?
        has_role?(:default)
      end

      def moderator?
        has_role?(:moderator)
      end

      def admin?
        has_role?(:admin)
      end

      def has_role?(role_name)
        role_symbols.include?(role_name.to_sym)
      end

      def role_empty?
        role_type_id.nil?
      end

      def role_symbols
        [role_type.try(:code)]
      end

      def role_symbol
        role_symbols.first
      end

      def state
        return 'active'   if active_for_authentication?
        return 'confirm'  unless confirmed?
        return 'suspend'  if access_locked?

        'pending'
      end

      protected

      def set_default_role
        self.role_type ||= ::RoleType.default
      end

      def check_role
        errors.add(:role_type_id, :invalid) unless ::RoleType.legal?(role_type_id)
      end
    end
  end
end

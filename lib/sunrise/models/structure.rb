# frozen_string_literal: true

require 'enum_field'

module Sunrise
  module Models
    module Structure
      extend ActiveSupport::Concern

      included do
        extend EnumField::EnumeratedAttribute

        enumerated_attribute :structure_type
        enumerated_attribute :position_type

        validates :title, presence: true
        validates :position_type_id, numericality: { only_integer: true }
        validates :structure_type_id, numericality: { only_integer: true }

        acts_as_nested_set

        before_validation :generate_slug, if: :should_generate_new_slug?

        scope :visible, -> { where(is_visible: true) }
        scope :with_type, ->(structure_type) { where(structure_type_id: structure_type.id) }
        scope :with_depth, ->(level) { where(depth: level.to_i) }
        scope :with_position, ->(position_type) { where(position_type_id: position_type.id) }
      end

      module ClassMethods
        def nested_set_options(mover = nil)
          result = []

          roots.each do |root|
            result += root.self_and_descendants.map do |i|
              [yield(i), i.id] if mover.nil? || mover.new_record? || mover.move_possible?(i)
            end.compact
          end
          result
        end
      end

      def moveable?
        new_record? || !root?
      end

      def descendants_count
        (right - left - 1) / 2
      end

      protected

      def generate_slug
        self.slug = Sunrise::Utils.normalize_friendly_id(title)
      end

      def should_generate_new_slug?
        base = title
        slug_value = slug

        # If the slug base is nil, and the slug field is nil, then we're going to leave the slug column NULL.
        return false if base.nil? && slug_value.nil?

        # Otherwise, if this is a new record, we're definitely going to try to create a new slug.
        slug_value.blank?
      end
    end
  end
end

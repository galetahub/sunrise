# encoding: utf-8
require 'enum_field'

module Sunrise
  module Models
    module Structure
      extend ActiveSupport::Concern
      
      included do
        extend EnumField::EnumeratedAttribute

        enumerated_attribute :structure_type, :id_attribute => :kind
        enumerated_attribute :position_type, :id_attribute => :position
        
        validates_presence_of :title
        validates_numericality_of :position, :only_integer => true
        
        acts_as_nested_set

        before_validation :generate_slug, :if => :should_generate_new_slug?
        
        scope :visible, lambda { where(:is_visible => true) }
        scope :with_kind, lambda {|structure_type| where(:kind => structure_type.id) }
        scope :with_depth, lambda {|level| where(:depth => level.to_i) }
        scope :with_position, lambda {|position_type| where(:position => position_type.id) }
      end
      
      module ClassMethods
        def nested_set_options(mover = nil)
          result = []
          
          roots.each do |root|
            result += root.self_and_descendants.map do |i|
              if mover.nil? || mover.new_record? || mover.move_possible?(i)
                [yield(i), i.id]
              end
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
          base = self.title
          slug_value = self.slug

          # If the slug base is nil, and the slug field is nil, then we're going to leave the slug column NULL.
          return false if base.nil? && slug_value.nil?
          
          # Otherwise, if this is a new record, we're definitely going to try to create a new slug.
          slug_value.blank?
        end
    end
  end
end

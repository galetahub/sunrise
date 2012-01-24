# encoding: utf-8
module Sunrise
  module Models
    module Structure
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.send(:include, Utils::Header)
          base.send(:include, ::PageParts::ActiveRecordExtension)
          base.class_eval do
            enumerated_attribute :structure_type, :id_attribute => :kind
            enumerated_attribute :position_type, :id_attribute => :position
            
            validates_presence_of :title
            validates_numericality_of :position, :only_integer => true
            
            acts_as_nested_set
            set_callback :move, :after, :update_depth
            
            extend ::FriendlyId
            friendly_id :title, :use => [:slugged, :static]
            
            scope :visible, where(:is_visible => true)
            scope :with_kind, proc {|structure_type| where(:kind => structure_type.id) }
            scope :with_depth, proc {|level| where(:depth => level.to_i) }
            scope :with_position, proc {|position_type| where(:position => position_type.id) }
            
            
            def self.nested_set_options(mover = nil)
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
        end
      end
      
      module InstanceMethods
        def moveable?
          new_record? || !root?
        end
      end
    end
  end
end

# encoding: utf-8
module Sunrise
  module Models
    module Role
      extend ActiveSupport::Concern
      
      included do 
        belongs_to :user
        
        enumerated_attribute :role_type, :id_attribute => :role_type
        attr_accessible :role_type
        
        scope :with_type, lambda { |role_type| where(:role_type => role_type) } 
      end
      
      module ClassMethods
      end
      

      def to_sym
        role_type.code
      end
    end
  end
end

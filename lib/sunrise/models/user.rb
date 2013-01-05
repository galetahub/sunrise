# encoding: utf-8
require "csv"
require "enum_field"

module Sunrise
  module Models
    module User
      extend ActiveSupport::Concern
      
      included do
        extend EnumField::EnumeratedAttribute
        
        enumerated_attribute :role_type
        
        has_one :avatar, :as => :assetable, :dependent => :destroy, :autosave => true
        
        before_validation :generate_login, :if => :has_login?
        before_validation :set_default_role, :if => :role_empty?
        
        validates_presence_of :name
        validate :check_role
        
        scope :with_email, lambda {|email| where(["email LIKE ?", "#{email}%"]) }
        scope :with_name, lambda {|name| where(["name LIKE ?", "#{name}%"]) }
        scope :with_role, lambda {|role_type| where(:role_type_id => role_type.id) }
        scope :defaults, lambda { with_role(::RoleType.default) }
        scope :moderators, lambda { with_role(::RoleType.moderator) }
        scope :admins, lambda { with_role(::RoleType.admin) }
      end
      
      module ClassMethods    
        def to_csv(options = {})
          options = { :columns => [:id, :email, :name, :current_sign_in_ip] }.merge(options)
          query = unscoped.order("#{quoted_table_name}.id ASC").select(options[:columns])
        
          ::CSV.generate do |csv|
            csv << options[:columns]
            
            query.find_in_batches do |group|
              group.each do |user|
                csv << options[:columns].inject([]) do |items, attr_name|
                  items << user.send(attr_name)
                end
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
        self.role_type_id.nil?
      end
      
      def has_login?
        respond_to?(:login)
      end
      	
      def role_symbols
        [role_type.try(:code)]
      end
      
      def role_symbol
        role_symbols.first
      end
      
      def state
        return 'active'   if active_for_authentication?
        return 'register' unless confirmed?
        return 'suspend'  if access_locked?
        return 'pending'
      end
      
      def events_for_current_state
        events = []
        events << 'activate' unless confirmed?
        events << 'unlock' if access_locked?
        # TODO: ban access for active users
        # events << 'suspend' if active_for_authentication?
        events
      end
      
      protected
        
        def set_default_role
          self.role_type ||= ::RoleType.default
        end
        
        def generate_login
          self.login ||= begin
            unless email.blank?
              tmp_login = email.split('@').first 
      		    tmp_login.parameterize.downcase.gsub(/[^A-Za-z0-9-]+/, '-').gsub(/-+/, '-')
      		  end
          end
        end

        def check_role
          errors.add(:role_type_id, :invalid) unless ::RoleType.legal?(role_type_id)
        end
    end
  end
end

# require 'cancan_namespace'

module Sunrise
  module Models
    class Ability
      include CanCan::Ability
      # include CanCanNamespace::Ability

      attr_accessor :context, :user

      def initialize(user, context = nil)
        # alias_action :delete, to: :destroy

        @user = (user || ::User.new) # guest user (not logged in)
        @context = context

        if @user.persisted? && @user.role_type
          send @user.role_type.code
        else
          guest
        end
      end

      def admin
        can :manage, :all
        # can :manage, :all, context: :sunrise

        # User cannot destroy self account
        # cannot :destroy, ::User, id: @user.id, context: :sunrise
        cannot :destroy, ::User, id: @user.id

        # User cannot destroy root structure
        # cannot :destroy, ::Structure, structure_type_id: ::StructureType.main.id, context: :sunrise
        cannot :destroy, ::Structure, structure_type_id: ::StructureType.main.id
      end
    end
  end
end

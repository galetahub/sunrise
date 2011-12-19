module Sunrise
  class ApplicationController < ::ApplicationController
    prepend_before_filter :authenticate_user!
    check_authorization
    
    protected
          
      def current_ability
        @current_ability ||= ::Ability.new(current_user, :manage)
      end
  end
end

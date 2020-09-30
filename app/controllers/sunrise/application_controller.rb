# frozen_string_literal: true

module Sunrise
  class ApplicationController < ::ApplicationController
    include ::PublicActivity::StoreController

    prepend_before_action :authenticate_user!
    check_authorization

    respond_to :html

    protected

    def current_ability
      @current_ability ||= ::Ability.new(current_user, :sunrise)
    end

    rescue_from ::CanCan::AccessDenied do |_exception|
      flash[:failure] = I18n.t(:access_denied, scope: [:flash, :users])

      respond_to do |format|
        format.html { redirect_to(user_signed_in? ? main_app.root_path : new_session_path(:user)) }
        format.any  { head :unauthorized }
      end
    end
  end
end

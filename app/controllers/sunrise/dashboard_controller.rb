module Sunrise
  class DashboardController < Sunrise::ApplicationController
    authorize_resource :class => false
    
    def index
      @events = Audit.page(params[:page]).per(50)
      respond_with(@events)
    end
  end
end

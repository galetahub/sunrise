module Sunrise
  class DashboardController < Sunrise::ApplicationController
    include Sunrise::Utils::SearchWrapper
    
    authorize_resource :class => false
    
    def index
      per_page = Sunrise::Config.audit_events_per_page
      cur_page = (params[:page] || 1).to_i
      offset = (cur_page - 1) * per_page
      
      @events = Audited.audit_class.includes(:user).limit(per_page).offset(offset)
      
      respond_with(@events) do |format|
        format.html { render :layout => params[:time].blank? }
      end
    end
  end
end

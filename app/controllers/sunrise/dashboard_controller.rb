module Sunrise
  class DashboardController < Sunrise::ApplicationController
    include Sunrise::Utils::SearchWrapper
    
    authorize_resource :class => false
    
    def index
      @events = Audited.audit_class.includes(:user).limit(Sunrise::Config.audit_events_per_page)
      respond_with(@events)
    end
  end
end

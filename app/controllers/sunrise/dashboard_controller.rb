module Sunrise
  class DashboardController < Sunrise::ApplicationController
    authorize_resource :class => false
    
    def index
    end
  end
end

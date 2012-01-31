module Sunrise
  class SharedController < Sunrise::ApplicationController
    authorize_resource :class => false
    
    respond_to :json, :only => [:services]
    
    def services
      @services = Structure.with_depth(1)
      respond_with(@services)
    end
  end
end

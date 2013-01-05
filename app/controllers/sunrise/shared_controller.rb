module Sunrise
  class SharedController < Sunrise::ApplicationController
    authorize_resource :class => false
    
    respond_to :json, :only => [:services]
    
    def services
      root = Structure.roots.first
      @services = root.children
      respond_with(@services)
    end
  end
end

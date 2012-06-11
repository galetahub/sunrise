module Sunrise
  class SettingsController < Sunrise::ApplicationController
    authorize_resource :class => false
    
    def edit
      @settings = Settings.all
      respond_with(@settings)
    end
    
    def update
      Settings.update_attributes(params[:settings])
      redirect_to root_path
    end
  end
end

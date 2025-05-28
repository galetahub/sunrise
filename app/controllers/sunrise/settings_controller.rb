# frozen_string_literal: true

module Sunrise
  class SettingsController < Sunrise::ApplicationController
    authorize_resource class: false

    def edit
      @settings = Settings.get_all
      respond_with(@settings)
    end

    def update
      Settings.update(params[:settings])
      redirect_to root_path
    end
  end
end

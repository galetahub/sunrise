# frozen_string_literal: true

module Sunrise
  class DashboardController < Sunrise::ApplicationController
    include Sunrise::Utils::SearchWrapper

    authorize_resource class: false

    def index; end
  end
end

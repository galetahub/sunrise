# encoding: utf-8
module Sunrise
  module Utils
    module SearchWrapper
      extend ActiveSupport::Concern
      
      included do
        helper_method :search_wrapper
      end
      
      protected
      
        def search_wrapper
          @search_wrapper ||= Sunrise::Views::SearchWrapper.new(params[:search])
        end
    end
  end
end

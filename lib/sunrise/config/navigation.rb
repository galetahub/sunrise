require 'sunrise/config/navigation_item'
require 'singleton'

module Sunrise
  module Config
    class Navigation
      include Singleton
      include Sunrise::Engine.routes.url_helpers
      
      attr_accessor :current_name
      attr_reader :navigations
      
      class << self
        # Configure menu items
        def navigation(name, options = nil)
          instance.current_name = name
          yield instance if block_given?
        end
        
        def method_missing(m, *args, &block)
          if instance.respond_to?(m)
            instance.send(m, *args, &block)
          else
            super
          end
        end
      end
      
      def initialize
        @navigations ||= {}
        @current_name = :main
      end
      
      def item(item_name, url = nil, options = {})
        url ||= index_path(:model_name => item_name)
        
        @navigations[current_name] ||= []
        @navigations[current_name] << NavigationItem.new(item_name, url, current_name, options)
      end
    end
  end
end

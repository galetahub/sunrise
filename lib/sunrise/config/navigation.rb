# frozen_string_literal: true

require 'sunrise/config/navigation_item'
require 'singleton'

module Sunrise
  module Config
    class Navigation
      include Singleton
      include Sunrise::Engine.routes.url_helpers

      attr_accessor :presenters

      class << self
        # Configure menu items
        def navigation(name, options = {}, &block)
          instance.presenters ||= {}
          instance.presenters[name] = PagePresenter.new(options, &block)
        end

        def method_missing(method_name, *args, &block)
          if instance.respond_to?(method_name)
            instance.send(method_name, *args, &block)
          else
            super
          end
        end
      end

      def initialize
        @navigations = nil
        @presenters = {}
        @current_name = :main
      end

      def navigations
        @navigations ||= build_navigation
      end

      def item(item_name, url = nil, options = {})
        url ||= index_path(model_name: item_name)

        @navigations[@current_name] ||= []
        @navigations[@current_name] << NavigationItem.new(item_name, url, @current_name, options)
      end

      protected

      def build_navigation
        @navigations = {}

        presenters.each do |key, presenter|
          @current_name = key.to_sym
          run_registration_block &presenter.block
        end

        @navigations
      end

      # Runs the registration block inside this object
      def run_registration_block(&block)
        instance_exec &block if block_given?
      end
    end
  end
end

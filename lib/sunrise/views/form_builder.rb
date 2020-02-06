# frozen_string_literal: true

require 'simple_form'
require 'sunrise/views/date_time_input'

module Sunrise
  module Views
    class FormBuilder < ::SimpleForm::FormBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::JavaScriptHelper

      def input(attribute_name, options = {}, &block)
        options[:input_html] ||= {}
        options[:input_html] = { class: 'text' }.merge(options[:input_html])

        attribute_name = "#{attribute_name}_#{options[:locale]}" if options[:locale].present?

        super(attribute_name, options, &block)
      end

      def globalize(options = {})
        locales = options[:locales] || Sunrise.available_locales
        html = []

        html.join.html_safe
      end

      protected

      def object_plural
        object_name.to_s.pluralize
      end
    end
  end
end

# frozen_string_literal: true

require 'simple_form'

module SimpleForm
  module Inputs
    class DateTimeInput < Base
      include ActionView::Helpers::TagHelper

      def input
        input_html_options[:value] ||= formated_value
        month_count = input_html_options[:month_count] || 1

        icon = "<div class='but-holder icon'><div class='act-but'><a class='but-container calend' href='javascript:void(0);' id='#{@builder.object_name}_#{attribute_name}_icon'><img src='/assets/sunrise/empty.gif' /></a></div></div>".html_safe
        html = [content_tag(:div, @builder.text_field(attribute_name, input_html_options) + icon, class: 'calend-holder')]

        html << case input_type
                when :date
                  @builder.javascript_tag("$(function() {
		          $('##{@builder.object_name}_#{attribute_name}').datepicker({
			          numberOfMonths: #{month_count},
			          showButtonPanel: true
		          });
		          $('##{@builder.object_name}_#{attribute_name}_icon').click(function(){
		            $('##{@builder.object_name}_#{attribute_name}').datepicker('show');
		          });
	          });")
                when :datetime
                  @builder.javascript_tag("$(function() {
		          $('##{@builder.object_name}_#{attribute_name}').datetimepicker({
			          numberOfMonths: #{month_count},
			          hourGrid: 4,
                minuteGrid: 10
		          });
		          $('##{@builder.object_name}_#{attribute_name}_icon').click(function(){
		            $('##{@builder.object_name}_#{attribute_name}').datetimepicker('show');
		          });
	          });")
        end

        html.join.html_safe
      end

      private

      def formated_value
        object.send(attribute_name).try(:strftime, value_format)
      end

      def value_format
        case input_type
        when :date then '%d.%m.%Y'
        when :datetime then '%d.%m.%Y %H:%M'
        when :time then '%H:%M'
        end
      end

      def has_required?
        false
      end

      def label_target
        case input_type
        when :date, :datetime
          "#{attribute_name}_1i"
        when :time
          "#{attribute_name}_4i"
        end
      end
    end
  end
end

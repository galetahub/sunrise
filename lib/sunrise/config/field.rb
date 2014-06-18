require 'sunrise/config/base'

module Sunrise
  module Config
    class Field < Base
      include Sunrise::Utils::EvalHelpers

      # The condition that must be met on an object
      attr_reader :if_condition
      
      # The condition that must *not* be met on an object
      attr_reader :unless_condition
      
      def initialize(abstract_model, parent, options = {})
        options = {:multiply => false, :sort => false}.merge(options)

        super(abstract_model, parent, options)
        
        # Build conditionals
        @if_condition = options.delete(:if)
        @unless_condition = options.delete(:unless)
      end
      
      def visible?(object = nil)
        object.nil? || matches_conditions?(object)
      end
      
      def input_options
        @config_options.dup
      end
      
      def human_name
        @config_options[:label] || abstract_model.model.human_attribute_name(@name)
      end
      
      def html_options
        css = ["padder"]
        css << "grey-but" if input_options[:boolean]
        css << "tags-edit" if association?
        
        {:class => css, :id => dom_id}.merge(input_options[:html] || {})
      end
      
      def association?
        input_options[:association] === true
      end
      
      def label?
        @config_options[:label] != false
      end

      def nested?
        false
      end

      def dom_id
        @dom_id ||= "#{name}_field"
      end

      protected
      
        # Verifies that the conditionals for this field evaluate to true for the
        # given object
        def matches_conditions?(object)
          return true if if_condition.nil? && unless_condition.nil?
          
          Array.wrap(if_condition).all? {|condition| evaluate_method(object, condition)} &&
          !Array.wrap(unless_condition).any? {|condition| evaluate_method(object, condition)}
        end
    end
  end
end

# frozen_string_literal: true

require 'ostruct'

module Sunrise
  module Views
    class SearchWrapper < ::OpenStruct
      extend ActiveModel::Naming

      def self.model_name
        @_model_name ||= begin
          namespace = parents.detect { |n| n.respond_to?(:_railtie) }
          ActiveModel::Name.new(self, namespace, 'search')
        end
      end
    end
  end
end

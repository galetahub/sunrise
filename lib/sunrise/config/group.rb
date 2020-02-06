# frozen_string_literal: true

require 'sunrise/config/base'
require 'sunrise/config/has_fields'

module Sunrise
  module Config
    class Group < Base
      include Sunrise::Config::HasFields

      def initialize(abstract_model, parent, name = :default, options = nil)
        options = { name: name }.merge(options || {})
        super(abstract_model, parent, options)
        @name = name.to_s.tr(' ', '_').downcase.to_sym
      end

      def title
        return false if @config_options[:title] === false

        @config_options[:title] || I18n.t(@name, scope: [:manage, :groups])
      end

      def sidebar?
        @config_options[:holder] == :sidebar
      end

      def bottom?
        @config_options[:holder] == :bottom
      end
    end
  end
end

module Sunrise
  module Config
    class NavigationItem
      attr_accessor :name, :url
      
      def initialize(name, url, scope = "items", options = {})
        @name = name
        @scope = scope
        @url = url
        @title = options.delete(:title)
        @options = options
      end
      
      def title
        @title ||= I18n.t(@name, :scope => [:manage, :menu, @scope])
      end
      
      def html_options
        @options.nil? ? {} : @options.dup
      end
    end
  end
end

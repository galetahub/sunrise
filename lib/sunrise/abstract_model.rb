require 'sunrise/config/model'

module Sunrise
  class AbstractModel
    
    class << self
      # Gets the resource_name
      def resource_name
        # Not using superclass_delegating_reader. See +site+ for explanation
        if defined?(@resource_name)
          @resource_name
        elsif superclass != Object && superclass.proxy
          superclass.proxy.dup.freeze
        end
      end
      
      # Set resource_name
      def resource_name=(name)
        @resource_name = name
      end
      
      def config
        @config ||= Config::Model.new(self)
      end
      
      def model
        @model ||= Utils.lookup(resource_name.to_s.camelize)
      end
      
      # Act as a proxy for the section configurations that actually
      # store the configurations.
      def method_missing(m, *args, &block)
        if config.respond_to?(m)
          config.send(m, *args, &block)
        else
          super
        end
      end
    end
    
    attr_accessor :model_name, :current_list, :scoped_path
        
    delegate :config, :model, :to => 'self.class'
    delegate :label, :to => 'self.class.config'
    
    def initialize
      @model_name = model.model_name
      @current_list = config.default_list_view
      @scoped_path = @model_name.plural
    end
    
    def current_list=(value)
      unless value.blank?
        @current_list = value.to_s.downcase.to_sym
      end
    end
    
    def list_key
      ["list", current_list].compact.join('_').to_sym
    end
    
    def list
      config.sections[list_key] ||= Config::List.new(self.class)
    end
    
    def apply_scopes(params)
      scope = model.respond_to?(:search) ? model.search(params) : model.scoped

      if current_list == :tree
        scope = scope.roots
      else
        scope = scope.merge(page_scope(params[:page], params[:per]))
        scope = scope.merge(sort_scope(params[:sort]))
      end
      
      scope
    end
    
    def page_scope(page = 1, per_page = nil)
      model.page(page).per(per_page || list.items_per_page)
    end
    
    def sort_scope(options = nil)
      options ||= { :column => list.sort_by }
      
      mode = list.sort_reverse? ? :desc : :asc
      
      model.order([options[:column], mode].join(' '))
    end
  end
end

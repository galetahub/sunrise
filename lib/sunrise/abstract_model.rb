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
      
      def abstract_class?
        defined?(@abstract_class) && @abstract_class == true
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
    delegate :param_key, :singular, :plural, :route_key, :to => :model_name
    
    def initialize(params = {})
      @model_name = model.model_name
      @current_list = config.default_list_view
      @scoped_path = @model_name.plural
      @request_params = params
      self.current_list = params[:view]
    end
    
    # Save current list view
    def current_list=(value)
      unless value.blank?
        @current_list = value.to_s.downcase.to_sym
      end
    end
    
    # Key which stored list settings
    def list_key
      ["list", current_list].compact.join('_').to_sym
    end
    
    # Read record request params
    def attrs
      @request_params[param_key.to_sym]
    end
    
    # Load association record
    def parent_record
      @parent_record ||= find_parent_record
    end
    
    # Convert parent id and class name into hash
    def parent_hash
      @parent_hash ||= { :parent_id => parent_record.id, :parent_type => parent_record.class.name } if parent_record
      @parent_hash ||= {}
    end
    
    # Get current list settings
    def list
      return false if without_list?
      config.sections[list_key] ||= Config::List.new(self.class)
    end
    
    # Is list config disabled
    def without_list?
      config.sections[:list] === false
    end
    
    def search_available?
      list && !list.groups[:search].nil?
    end
    
    # Initialize new model and set parent record
    def build_record
      record = model.new
      
      if parent_record
        record.send("#{parent_association.name}=", parent_record)
      end
      
      record
    end
    
    # Convert request params to model scopes
    def apply_scopes(params = nil)
      raise ::ActiveRecord::RecordNotFound, "List config is turn off" if without_list?
      params ||= @request_params
      
      scope = default_scope(params)

      if current_list == :tree
        scope = scope.roots
      else
        scope = scope.merge(page_scope(params[:page], params[:per]))
      end
      
      scope
    end
    
    # Apply default scopes: sort, search and association.
    def default_scope(params = nil)
      params ||= @request_params
      
      scope = model.sunrise_search(params[:search]) if model.respond_to?(:sunrise_search) && !params[:search].blank?
      scope ||= model.scoped
      
      scope = scope.merge(association_scope) unless parent_record.nil?
      scope = scope.merge(sort_scope(params[:sort])) unless params[:sort].blank?
      
      scope
    end
    
    def association_scope
      if parent_record
        parent_record.send(@scoped_path).scoped
      end
    end
    
    def page_scope(page = 1, per_page = nil)
      model.page(page).per(per_page || list.items_per_page)
    end
    
    def sort_scope(options = nil)
      options ||= { :column => list.sort_by }
      
      mode = list.sort_reverse? ? :desc : :asc
      
      model.order([options[:column], mode].join(' '))
    end
    
    def export_scope(options = nil)
      scope = default_scope(options)
      scope = scope.merge(config.export.scope)
      scope
    end
    
    # List of columns names to be exported
    def export_columns
      if config.export.fields
        config.export.fields.map(&:name)
      else
        model.column_names
      end
    end
    
    # Filename for export data
    def export_filename
      @export_filename ||= [plural, Time.now.strftime("%Y-%m-%d_%Hh%Mm%S")].join('_')
    end
    
    protected
      
      # Try to find parent object if any association present
      def find_parent_record
        if parent_present? && parent_valid?
          parent_association.model.find(@request_params[:parent_id])
        end
      end
      
      # Find related association in model config
      def parent_association
        @parent_association ||= config.associations.detect { |relation| relation.is_this?(@request_params[:parent_type]) }
      end
      
      # Parent association exists
      def parent_valid?
        !parent_association.nil?
      end
      
      # Check parent record in request params
      def parent_present?
        !(@request_params[:parent_id].blank? || @request_params[:parent_type].blank?)
      end
  end
end

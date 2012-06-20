require 'sunrise/config/model'
require 'ostruct'

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
    
    attr_accessor :model_name, :current_list, :sort_column, :scoped_path, :available_list_view
        
    delegate :config, :model, :to => 'self.class'
    delegate :label, :to => 'self.class.config'
    delegate :param_key, :singular, :plural, :route_key, :to => :model_name
    
    def initialize(params = {})
      @model_name = model.model_name
      @current_list = config.default_list_view
      @available_list_view = config.available_list_view
      @sort_column = config.sort_column
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
    
    def sort_available?
      list && !list.groups[:sort].nil?
    end
    
    def sort_fields
      @sort_fields ||= list.groups[:sort].fields.inject([]) do |items, field|
        [:desc, :asc].each do |direction|
          name = [field.name, direction].join('_')
          items << OpenStruct.new(:name => I18n.t(name, :scope => [:manage, :sort_columns]), :value => name)
        end
        
        items
      end
    end
    
    def update_sort(params)
      if !params[:ids].blank?
        update_sort_column(params[:ids])
      elsif !params[:tree].blank?
        update_sort_tree(params[:tree])
      end
    end
    
    # Update nested tree
    # {"id"=>{"parent_id"=>"root", "depth"=>"0", "left"=>"1", "right"=>"22"}
    #
    def update_sort_tree(ids)
      return nil if ids.empty?
      
      ids.each do |key, value|
        hash = { :parent_id => nil, :depth => value[:depth], :lft => value[:left], :rgt => value[:right] }
        hash[:parent_id] = value[:parent_id] unless value[:parent_id] == "root"
        model.where(:id => key).update_all(hash)
      end
    end
    
    def update_sort_column(ids)
      return nil if ids.empty?
      
      sql_case = '' 
      ids.each do |key, value| 
        sql_case += "WHEN #{key} THEN #{value} "
      end
      sql_case += 'END'
      
      model.update_all("#{@sort_column} = CASE id #{sql_case}", ["id IN (?)", ids.keys.map(&:to_i)])
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
      raise ::AbstractController::ActionNotFound.new("List config is turn off") if without_list?
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
      scope = scope.merge(list.scope) unless list.scope.nil?
      
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
      options = Utils.sort_to_hash(options) if options.is_a?(String)
      options = { :column => list.sort_column, :mode => list.sort_mode }.merge(options || {})
      
      options[:column] = list.sort_column if options[:column].blank?
      options[:mode] = list.sort_mode     if options[:mode].blank?
      
      model.order([options[:column], options[:mode]].join(' '))
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
    
    def edit_fields
      config.edit.fields || []
    end
    
    # Has translated columns
    def translate?
      !config.edit.groups[:translate].blank?
    end
    
    # Files to translate
    def translate_fields
      config.edit.groups[:translate].try(:fields) || []
    end
    
    # Find sidebar groups
    def sidebar_groups
      @sidebar_groups ||= config.edit.groups.values.select { |v| v.sidebar? }
    end
    
    # Check if sidebar groups exists
    def sidebar_groups?
      !sidebar_groups.empty?
    end
    
    # Find bottom groups
    def bottom_groups
      @bottom_groups ||= config.edit.groups.values.select { |v| v.bottom? }
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

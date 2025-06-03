# frozen_string_literal: true

require 'sunrise/config/model'
require 'ostruct'

module Sunrise
  class AbstractModel
    extend ::ActiveModel::Callbacks

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
      attr_writer :resource_name

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

    attr_accessor :model_name, :current_list, :sort_column, :available_list_view

    delegate :config, :model, to: 'self.class'
    delegate :label, to: 'self.class.config'
    delegate :param_key, :singular, :plural, :route_key, to: :model_name

    define_model_callbacks :sort, :mass_destroy, only: %i[before after]

    def initialize(params = {})
      @model_name = model.model_name
      @current_list = config.default_index_view
      @available_index_views = config.available_index_views
      @sort_column = config.sort_column
      @request_params = params.try(:symbolize_keys) || params
      self.current_list = params[:view]
    end

    def model_params
      @request_params[param_key.to_sym] || {}
    end

    def permit_model_params(*filters)
      params = @request_params[param_key.to_sym]

      if params
        filters.empty? ? params.permit! : params.permit(*filters)
      else
        {}
      end
    end

    # Save current list view
    def current_list=(value)
      @current_list = value.to_sym if value && @available_index_views.include?(value.to_sym)
    end

    # Load association record
    def parent_record
      @parent_record ||= find_parent_record
    end

    # Convert parent id and class name into hash
    def parent_hash
      if parent_record
        @parent_hash ||= { parent_id: parent_record.id, parent_type: parent_record.class.name.underscore }
      end
      @parent_hash ||= {}
    end

    # Get current list settings
    def list
      return false if without_index?

      config.index(current_list)
    end

    # Is index config disabled
    def without_index?
      config.index === false
    end

    def search_available?
      list && !list.groups[:search].nil?
    end

    def sort_available?
      list && !list.groups[:sort].nil?
    end

    def sort_fields
      @sort_fields ||= list.groups[:sort].fields.each_with_object([]) do |field, items|
        [:desc, :asc].each do |direction|
          name = [field.name, direction].join('_')
          items << OpenStruct.new(name: I18n.t(name, scope: [:manage, :sort_columns]), value: name)
        end
      end
    end

    def update_sort(params)
      run_callbacks :sort do
        if params[:ids].present?
          update_sort_column(params[:ids])
        elsif params[:tree].present?
          update_sort_tree(params[:tree])
        end
      end
    end

    def destroy_all(params)
      return if params[:ids].blank?

      run_callbacks :mass_destroy do
        model.where(id: params[:ids]).destroy_all
      end
    end

    # Update nested tree
    # {"id"=>{"parent_id"=>"root", "depth"=>"0", "left"=>"1", "right"=>"22"}
    #
    def update_sort_tree(ids)
      return nil if ids.empty?

      ids.each do |key, value|
        hash = { parent_id: nil, depth: value[:depth], lft: value[:left], rgt: value[:right] }
        hash[:parent_id] = value[:parent_id] unless value[:parent_id] == 'root'
        model.where(id: key).update_all(hash)
      end
    end

    def update_sort_column(ids)
      return nil if ids.empty?

      ids.each do |key, value|
        model.where(id: key).update_all(@sort_column => value)
      end
    end

    # Initialize new model, sets parent record and call build_defaults method
    def build_record
      record = model.new
      record.send("#{parent_association.name}=", parent_record) if parent_record
      record.build_defaults if record.respond_to?(:build_defaults)
      record
    end

    # Convert request params to model scopes
    def apply_scopes(params = nil, pagination = true)
      raise ::AbstractController::ActionNotFound, 'List config is turn off' if without_index?

      params ||= @request_params

      scope = default_scope(params)

      if current_list == :tree
        scope = scope.roots
      elsif pagination
        scope = page_scope(scope, params[:page], params[:per])
      end

      scope
    end

    # Apply default scopes: sort, search and association.
    def default_scope(params = nil)
      params ||= @request_params

      if model.respond_to?(:sunrise_search) && params[:search].present?
        scope = model.sunrise_search(params[:search])
      end
      scope ||= model.all

      scope = scope.merge(association_scope) unless parent_record.nil?
      scope = scope.merge(sort_scope(params[:sort])) if params[:sort].present?
      scope = scope.merge(list.scope) unless list.scope.nil?

      scope
    end

    def association_scope
      parent_record&.send(parent_association.relation_name)
    end

    def page_scope(scope, page = 1, per_page = nil)
      page = 1 if page.blank? || page.to_i <= 0
      per_page ||= list.items_per_page

      scope.page(page).per(per_page)
    end

    def sort_scope(options = nil)
      options = Utils.sort_to_hash(options) if options.is_a?(String)
      options = { column: list.sort_column, mode: list.sort_mode }.merge(options || {})

      options[:column] = list.sort_column if options[:column].blank?
      options[:mode] = list.sort_mode     if options[:mode].blank?

      model.order([options[:column], options[:mode]].join(' '))
    end

    # List of columns names to be exported
    def export_columns
      @export_columns ||= (config.export ? config.export.fields.map(&:name) : model.column_names)
    end

    # Filename for export data
    def export_filename
      @export_filename ||= [plural, Time.zone.now.strftime('%Y-%m-%d_%Hh%Mm%S')].join('_')
    end

    def export_options
      {
        filename: export_filename,
        columns: export_columns
      }
    end

    def form_fields
      config.form.fields || []
    end

    def permit_attributes(params, user = nil)
      value = config.form.permited_attributes

      attrs = case value
              when Proc then value.call(user)
              when String then value.to_sym
              else value
      end

      if attrs == :all
        params.require(param_key).permit!
      else
        attrs = Array.wrap(attrs).map(&:to_sym)
        params.require(param_key).permit(*attrs)
      end
    end

    # Has translated columns
    def translate?
      config.form.groups[:translate].present?
    end

    # Files to translate
    def translate_fields
      config.form.groups[:translate].try(:fields) || []
    end

    # Find sidebar groups
    def sidebar_groups
      @sidebar_groups ||= config.form.groups.values.select { |v| v.sidebar? }
    end

    # Check if sidebar groups exists
    def sidebar_groups?
      !sidebar_groups.empty?
    end

    # Find bottom groups
    def bottom_groups
      @bottom_groups ||= config.form.groups.values.select { |v| v.bottom? }
    end

    protected

    # Try to find parent object if any association present
    def find_parent_record
      parent_association.model.find(@request_params[:parent_id]) if parent_present? && parent_valid?
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

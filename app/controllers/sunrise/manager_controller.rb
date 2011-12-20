module Sunrise
  class ManagerController < Sunrise::ApplicationController
    before_filter :build_record, :only => [:new, :create]
    before_filter :find_record, :only => [:show, :edit, :update, :destroy]
    before_filter :authorize_resource
    
    helper_method :abstract_model
    
    respond_to :html, :xml, :json
    
    def index
      abstract_model.current_list = params[:view]
      @records = abstract_model.apply_scopes(params)
      
      respond_with(@records) do |format|
        format.html { render_with_scope(abstract_model.current_list) }
      end
    end
    
    def new
      respond_with(@record) do |format|
        format.html { render_with_scope } 
      end
    end
    
    def create
      @record.update_attributes(record_params, :as => :admin)
      respond_with(@record, :location => index_path)
    end
    
    def edit
      respond_with(@record) do |format|
        format.html { render_with_scope } 
      end
    end
    
    def update
      @record.update_attributes(record_params, :as => :admin)
      respond_with(@record, :location => index_path)
    end
    
    def destroy
      @record.destroy
      respond_with(@record, :location => index_path)
    end
    
    protected
    
      def find_model
        @abstract_model = Utils.get_model(params[:model_name])
        raise ActiveRecord::RecordNotFound, "Sunrise model #{params[:model_name]} not found" if @abstract_model.nil?
        @abstract_model
      end
      
      def abstract_model
        @abstract_model ||= find_model
      end
      
      def build_record
        @record = abstract_model.model.new
      end
      
      def find_record
        @record = abstract_model.model.find(params[:id])
      end
      
      def record_params
        params[abstract_model.model_name]
      end
      
      # Render a view for the specified scope. Turned off by default.
      # Accepts just :controller as option.
      def render_with_scope(scope = nil, action = self.action_name, path = self.controller_path)
        templates = [ [path, action] ]
        templates << [path, scope, action]
        
        if Sunrise::Config.scoped_views?
          templates << [abstract_model.scoped_path, path.split("/").last, scope, action]
        end
        
        templates.reverse.each do |keys|
          name = keys.compact.join('/')
          return render(:template => name) if template_exists?(name)
        end
      end
      
      def authorize_resource
        authorize!(action_name, @record || abstract_model.model)
      end
  end
end

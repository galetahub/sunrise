# encoding: utf-8
module Sunrise
  module Models
    module Asset
      extend ActiveSupport::Concern
      
      included do
        belongs_to :user
        belongs_to :assetable, :polymorphic => true
        
        # Store options for image manipulation
        attr_reader :cropper_geometry, :rotate_degrees
        
        before_save :reprocess
        
        delegate :url, :original_filename, :to => :data
        alias :filename :original_filename
      end
      
      module ClassMethods        
        def move_to(index, id)
          update_all(["sort_order = ?", index], ["id = ?", id.to_i])
        end
      end
      
        
      def thumb_url
        data.thumb.url
      end
      
      def format_created_at
        I18n.l(created_at, :format => "%d.%m.%Y %H:%M")
      end
      
      def to_xml(options = {}, &block)
        options = {:only => [:id], :root => 'asset'}.merge(options)
        
        options[:procs] ||= Proc.new do |options, record| 
          options[:builder].tag!('filename', filename)
          options[:builder].tag!('path', url)
          options[:builder].tag!('size', data_file_size)
        end
        
        super
      end
      
      def as_json(options = nil)
        options = {
          :only => [:id, :guid, :assetable_id, :assetable_type, :user_id, :data_file_size, :data_content_type], 
          :root => 'asset',
          :methods => [:filename, :url, :thumb_url]
        }.merge(options || {})
        
        super
      end
      
      def has_dimensions?
        respond_to?(:width) && respond_to?(:height)
      end
      
      def image?
        Sunrise::Utils::IMAGE_TYPES.include?(self.data_content_type)
      end
      
      def cropper_geometry=(value)
        geometry = (value || '').to_s.split(',')
        
        unless geometry.map(&:blank?).any?
          @cropper_geometry_changed = true
          @cropper_geometry = geometry
        end
      end
      
      def cropper_geometry_changed?
        @cropper_geometry_changed === true
      end
      
      def rotate_degrees=(value)
        unless value.blank?
          @rotate_degrees_changed = true
          @rotate_degrees = value.to_s
        end
      end
      
      def rotate_degrees_changed?
        @rotate_degrees_changed === true
      end
      
      protected
      
        def reprocess
          if cropper_geometry_changed? || rotate_degrees_changed?
            data.cache_stored_file!
          end
        end
    end
  end
end

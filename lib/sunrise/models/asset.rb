# frozen_string_literal: true

module Sunrise
  module Models
    module Asset
      extend ActiveSupport::Concern

      included do
        belongs_to :user
        belongs_to :assetable, polymorphic: true

        # Store options for image manipulation
        attr_reader :cropper_geometry, :rotate_degrees

        before_save :reprocess

        delegate :url, :original_filename, to: :data
      end

      module ClassMethods
        def move_to(index, id)
          update_all(['sort_order = ?', index], ['id = ?', id.to_i])
        end
      end

      def thumb_url
        data.thumb.url
      end

      def filename
        data_file_name
      end

      def size
        data_file_size
      end

      def content_type
        data_content_type
      end

      def format_created_at
        I18n.l(created_at, format: '%d.%m.%Y %H:%M')
      end

      def to_xml(options = {}, &block)
        options = { only: [:id], root: 'asset' }.merge(options)

        options[:procs] ||= proc do |options, _record|
          options[:builder].tag!('filename', filename)
          options[:builder].tag!('path', url)
          options[:builder].tag!('size', data_file_size)
        end

        super
      end

      def as_json(options = nil)
        options = {
          root: 'asset',
          only: [:id, :guid, :assetable_id, :assetable_type, :user_id, :public_token],
          methods: [:filename, :url, :thumb_url, :size, :content_type]
        }.merge(options || {})

        super(options)
      end

      def has_dimensions?
        respond_to?(:width) && respond_to?(:height)
      end

      def image?
        Sunrise::Utils::IMAGE_TYPES.include?(data_content_type)
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
        if value.present?
          @rotate_degrees_changed = true
          @rotate_degrees = value.to_s
        end
      end

      def rotate_degrees_changed?
        @rotate_degrees_changed === true
      end

      def uploader_user(request)
        request.env['warden'].user
      end

      def uploader_create(params, request = nil)
        if uploader_can?(:create, request)
          self.user_id = uploader_user(request).try(:id)
          params[:assetable_type] = 'Noname' if params[:assetable_type].blank?
          params[:assetable_id] = 0 if params[:assetable_id].blank?
          super
        else
          errors.add(:id, :access_denied)
        end
      end

      def uploader_destroy(params, request = nil)
        if uploader_can?(:delete, request)
          super
        else
          errors.add(:id, :access_denied)
        end
      end

      def uploader_can?(action, request)
        ability = ::Ability.new(uploader_user(request))
        ability.can? action.to_sym, self
      end

      protected

      def reprocess
        data.cache_stored_file! if cropper_geometry_changed? || rotate_degrees_changed?
      end
    end
  end
end

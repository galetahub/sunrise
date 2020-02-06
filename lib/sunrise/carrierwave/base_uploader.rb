# frozen_string_literal: true

require 'mime/types'
require 'mini_magick'
require 'carrierwave/processing/mini_magick'
require 'carrierwave/processing/mime_types'

module Sunrise
  module CarrierWave
    class BaseUploader < ::CarrierWave::Uploader::Base
      include ::CarrierWave::MiniMagick
      include ::CarrierWave::MimeTypes
      include Sunrise::Utils::EvalHelpers

      storage :file

      process :set_content_type

      with_options if: :image? do |img|
        img.process :strip
        img.process cropper: ->(model) { model.cropper_geometry }
        img.process rotate: ->(model) { model.rotate_degrees }
      end

      process :set_model_info

      # default store assets path
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{model.id}"
      end

      # Strips out all embedded information from the image
      # process :strip
      #
      def strip
        manipulate! do |img|
          img.strip
          img = yield(img) if block_given?
          img
        end
      end

      # Reduces the quality of the image to the percentage given
      # process :quality => 85
      #
      def quality(percentage)
        percentage = normalize_param(percentage)

        if percentage.present?
          manipulate! do |img|
            img.quality(percentage.to_s)
            img = yield(img) if block_given?
            img
          end
        end
      end

      # Rotate image by degress
      # process :rotate => "-90"
      #
      def rotate(degrees = nil)
        degrees = normalize_param(degrees)

        if degrees.present?
          manipulate! do |img|
            img.rotate(degrees.to_s)
            img = yield(img) if block_given?
            img
          end
        end
      end

      # Crop image by specific coordinates
      # http://www.imagemagick.org/script/command-line-processing.php?ImageMagick=6ddk6c680muj4eu2vr54vdveb7#geometry
      # process :cropper => [size, offset]
      # process :cropper => [800, 600, 10, 20]
      #
      def cropper(*geometry)
        geometry = normalize_param(geometry[0]) if geometry.size == 1

        if geometry && geometry.size == 4
          manipulate! do |img|
            img.crop '%ix%i+%i+%i' % geometry
            img = yield(img) if block_given?
            img
          end
        end
      end

      def default_url
        image_name = [model.class.to_s.underscore, version_name].compact.join('_')
        "/assets/defaults/#{image_name}.png"
      end

      def image?(new_file = nil)
        _type = (file || new_file).content_type
        _type.include?('image') && %w[photoshop psd].none? { |p| _type.include?(p) }
      end

      def dimensions
        [magick[:width], magick[:height]]
      end

      def magick
        @magick ||= ::MiniMagick::Image.new(current_path)
      end

      protected

      def set_model_info
        model.data_content_type = file.content_type
        model.data_file_size = file.size

        model.width, model.height = dimensions if image? && model.has_dimensions?
      end

      def normalize_param(value)
        if value.is_a?(Proc) || value.is_a?(Method)
          evaluate_method(model, value, file)
        else
          value
        end
      end
    end
  end
end

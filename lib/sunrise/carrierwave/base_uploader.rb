# encoding: utf-8
require 'mime/types'
require 'mini_magick'

module Sunrise
  module CarrierWave
    class BaseUploader < ::CarrierWave::Uploader::Base
      include ::CarrierWave::MiniMagick
            
      storage :file
      
      process :set_content_type
      process :set_size
      process :set_width_and_height
       
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
        manipulate! do |img|
          img.quality(percentage.to_s)
          img = yield(img) if block_given?
          img
        end
      end
      
      # Rotate image by degress
      # process :rotate => "-90"
      #
      def rotate(degrees)
        manipulate! do |img|
          img.rotate(degrees.to_s)
          img = yield(img) if block_given?
          img
        end
      end
      
      def default_url
        image_name = [model.class.to_s.underscore, version_name].compact.join('_')
        "/assets/defaults/#{image_name}.png"
      end
      
      def image?
        model.image?
      end
      
      protected
      
        def set_content_type
          model.data_content_type = if file.content_type.blank? || file.content_type == 'application/octet-stream'
            MIME::Types.type_for(original_filename).first.to_s
          else
            file.content_type
          end
        end 
        
        def set_size
          model.data_file_size = file.size
        end
        
        def set_width_and_height
          if model.image? && model.has_dimensions?
            magick = ::MiniMagick::Image.new(current_path)
            model.width, model.height = magick[:width], magick[:height]
          end
        end

    end
  end
end

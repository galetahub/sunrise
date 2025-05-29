# frozen_string_literal: true

class PictureUploader < Sunrise::CarrierWave::BaseUploader
  process quality: 90
  process :set_dimensions

  version :thumb do
    process resize_to_fill: [50, 50]
  end

  version :content do
    process resize_to_fit: [575, 500]
  end

  def extension_white_list
    %w[jpg jpeg gif png]
  end

  def size_range
    100..2.megabytes.to_i
  end
end

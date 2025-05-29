# frozen_string_literal: true

class AvatarUploader < Sunrise::CarrierWave::BaseUploader
  process quality: 90
  process :set_dimensions

  version :thumb do
    process resize_to_fill: [100, 100]
  end

  version :small do
    process resize_to_fill: [32, 32]
  end

  def extension_white_list
    %w[jpg jpeg gif png]
  end

  def size_range
    100..1.megabytes.to_i
  end
end

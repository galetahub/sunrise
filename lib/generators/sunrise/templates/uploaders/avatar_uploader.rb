class AvatarUploader < Sunrise::CarrierWave::BaseUploader
  process :quality => 90
  
  version :thumb do
    process :resize_to_fill => [50, 50]
  end
  
  version :small do
    process :resize_to_fill => [32, 32]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end

class PictureUploader < Sunrise::CarrierWave::BaseUploader
  process :quality => 90
  
  version :thumb do
    process :resize_to_fill => [100, 100]
  end

  version :content do
    process :resize_to_fit => [575, 500]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end

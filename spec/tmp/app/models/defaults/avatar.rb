class Avatar < Asset
  sunrise_uploader AvatarUploader  
  
	validates :data_content_type, :inclusion => {:in => Sunrise::Utils::IMAGE_TYPES }
	validates_integrity_of :data
	validates_filesize_of :data, :maximum => 1.megabytes.to_i
end

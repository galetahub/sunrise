class AttachmentFile < Asset
  sunrise_uploader AttachmentFileUploader
  
  validates_filesize_of :data, :maximum => 100.megabytes.to_i
end

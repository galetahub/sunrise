# frozen_string_literal: true

class Picture < Asset
  sunrise_uploader PictureUploader

  validates :data_content_type, inclusion: { in: Sunrise::Utils::IMAGE_TYPES }
  validates_integrity_of :data
  validates_filesize_of :data, maximum: 2.megabytes.to_i
end

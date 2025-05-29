# frozen_string_literal: true

class Picture < Asset
  sunrise_uploader PictureUploader

  validates :data_content_type, inclusion: { in: Sunrise::Utils::IMAGE_TYPES }
end

# frozen_string_literal: true

class Avatar < Asset
  sunrise_uploader AvatarUploader

  validates :data_content_type, inclusion: { in: Sunrise::Utils::IMAGE_TYPES }
end

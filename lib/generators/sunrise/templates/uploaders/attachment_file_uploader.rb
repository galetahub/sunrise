# frozen_string_literal: true

class AttachmentFileUploader < Sunrise::CarrierWave::BaseUploader
  def extension_white_list
    %w[pdf doc docx xls xlsx ppt pptx zip rar csv]
  end

  def size_range
    100...100.megabytes.to_i
  end
end

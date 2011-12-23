module Sunrise
  module ApplicationHelper
    def manage_icon(image, options = {})
      options = { :alt => t(image, :scope => 'manage.icons'), :title => t(image, :scope => 'manage.icons') }.merge(options)
      image_tag("sunrise/ico_#{image}.gif", options)
    end
  end
end

module Sunrise
  module ManagerHelper
    def manage_form_for(object, *args, &block)
      options = args.extract_options!
      
      options[:builder] ||= Sunrise::Views::FormBuilder
      options[:url] ||= (object.new_record? ? new_path : edit_path(object))
      
      simple_form_for(object, *(args << options), &block)
    end
    
    def manage_icon(image, options = {})
      options = { :alt => t(image, :scope => 'manage.icons'), :title => t(image, :scope => 'manage.icons') }.merge(options)
      image_tag("sunrise/ico_#{image}.gif", options)
    end
  end
end

module Sunrise
  module ManagerHelper
    def manage_form_for(object, *args, &block)
      options = args.extract_options!
      
      options[:builder] ||= Sunrise::Views::FormBuilder
      options[:url] ||= (object.new_record? ? new_path : edit_path(object))
      
      simple_form_for(object, *(args << options), &block)
    end
  end
end

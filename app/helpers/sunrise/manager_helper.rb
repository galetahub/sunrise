module Sunrise
  module ManagerHelper
    
    def manage_form_for(object, *args, &block)
      options = args.extract_options!
      
      options[:builder] ||= Sunrise::Views::FormBuilder
      options[:url] ||= (object.new_record? ? new_path : edit_path(:id => object.id))
      
      simple_form_for(object, *(args << options), &block)
    end
    
    def manage_date_tag(datetime, options={})
      options = {:hide_time => datetime.is_a?(Date) }.merge(options)
      tags = []
      
      tags << content_tag(:div, datetime.strftime("%d.%m.%Y"), :class => 'date')
      tags << content_tag(:div, datetime.strftime("%H:%M"), :class => 'time') unless options[:hide_time]
      
      content_tag(:div, tags.join.html_safe, :class => 'date-time')
    end
    
    def render_field(field, record)
      item = record.send(field.name)
      
      if [Date, DateTime, Time].detect{|klass| item.is_a?(klass)}
        manage_date_tag(item)
      elsif item.is_a?(String)
        item =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i ? mail_to(item) : item
      else
        item.to_s
      end
    end
    
    def render_header(options={})
      action ||= controller.action_name
    
      partials = options[:partials] || []
      partials << "sunrise/#{controller.controller_name}/header_#{action}"
      partials << "sunrise/#{controller.controller_name}/header"
      partials << "sunrise/shared/header"
      
      partials.each do |pname|
        return render(:partial => pname) if lookup_context.exists?(pname, [], true)
      end
      
      return ''
    end
  end
end

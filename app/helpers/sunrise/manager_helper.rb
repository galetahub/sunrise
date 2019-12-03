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

    def manage_render_field(field, record)
      item = record.send(field.name)

      if [Date, DateTime, Time].detect{|klass| item.is_a?(klass)}
        manage_date_tag(item)
      elsif item.is_a?(String)
        item =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i ? mail_to(item) : item
      else
        item.to_s
      end
    end

    def manage_remove_child_link(name, form, options = {})
      options[:onclick] = h("sunrise.remove_fields(this);")
      form.hidden_field(:_destroy) + link_to(name, "javascript:void(0);", options)
    end

    def manage_add_child_link(name, form, field, options = {})
      options.symbolize_keys!

      method = field.name.to_sym
      html_options = (options.delete(:html) || {})
      fields = manage_new_child_fields(form, field, options)

      html_options[:class] ||= "button"
      html_options[:onclick] = h("sunrise.insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\");")

      link_to(name, "javascript:void(0);", html_options)
    end

    def manage_new_child_fields(form_builder, field, options = {})
      method = field.name.to_sym

      options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
      options[:partial] ||= method.to_s.singularize
      options[:form_builder_local] ||= :form

      form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
        render(:partial => options[:partial], :locals => { options[:form_builder_local] => f, :field => field })
      end
    end
  end
end

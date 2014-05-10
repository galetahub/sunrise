module Sunrise
  module ActivitiesHelper

    # For generating time tags calculated using jquery.timeago
    def timeago_tag(time, options = {})
      options[:class] ||= "timeago"
      content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
    end

    def activity_icon_tag(key, options = {})
      icon = key.split('.').last
      image = image_path("sunrise/icons/#{icon}.svg")

      options = {
        :class => "mega-icon",
        :style => "background-image: url(#{image});"
      }.merge(options)

      content_tag(:div, nil, options)
    end

    # Check if object still exists in the database and display a link to it,
    # otherwise display a proper message about it.
    # This is used in activities that can refer to
    # objects which no longer exist, like removed posts.
    def link_to_trackable(object, object_type)
      model_name = object_type.downcase

      if object
        link_to(model_name, edit_path(:model_name => model_name.pluralize, :id => object.id))
      else
        "a #{model_name} which does not exist anymore"
      end
    end
  end
end
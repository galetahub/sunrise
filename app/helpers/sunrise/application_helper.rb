# frozen_string_literal: true

module Sunrise
  module ApplicationHelper
    def manage_icon(image, options = {})
      options = { alt: t(image, scope: 'manage.icons'), title: t(image, scope: 'manage.icons') }.merge(options)
      image_tag("sunrise/ico_#{image}.gif", options)
    end

    def manage_render_header(options = {})
      action = controller.action_name
      action = 'new' if action == 'create'
      action = 'edit' if action == 'update'

      partials = options[:partials] || []
      partials << "sunrise/#{controller.controller_name}/header_#{action}"
      partials << "sunrise/#{controller.controller_name}/header"
      partials << 'sunrise/shared/header'

      partials.each do |pname|
        return render(partial: pname) if lookup_context.exists?(pname, [], true)
      end

      ''
    end
  end
end

# frozen_string_literal: true

module Sunrise
  module Views
    module Helper
      def javascript(*args)
        content_for(:head) { javascript_include_tag(*args) }
      end

      def stylesheet(*args)
        content_for(:head) { stylesheet_link_tag(*args) }
      end

      def link_by_href(name, options = {})
        link_to name, name, options
      end

      def link_to_unless_current_span(name, options = {}, html_options = {}, &block)
        link_to_unless_span current_page?(options), name, options, html_options, &block
      end

      def link_to_unless_span(condition, name, options = {}, html_options = {}, &block)
        if condition
          if block_given?
            block.arity <= 1 ? yield(name) : yield(name, options, html_options)
          else
            content_tag(:span, name, html_options)
          end
        else
          link_to(name, options, html_options)
        end
      end

      def link_to_unless_current_tag(name, options = {}, html_options = {}, &block)
        link_to_unless_tag current_page?(options), name, options, html_options, &block
      end

      def link_to_if_tag(condition, name, options = {}, html_options = {}, &block)
        tag_name = html_options.delete(:tag) || :span
        if condition
          link_to(name, options, html_options)
        else
          if block_given?
            block.arity <= 1 ? yield(name) : yield(name, options, html_options)
          else
            content_tag(tag_name, name, html_options)
          end
        end
      end

      def link_to_unless_tag(condition, name, options = {}, html_options = {}, &block)
        tag_name = html_options.delete(:tag) || :span
        if condition
          if block_given?
            block.arity <= 1 ? yield(name) : yield(name, options, html_options)
          else
            content_tag(tag_name, name, html_options)
          end
        else
          link_to(name, options, html_options)
        end
      end

      # swf_object
      def swf_object(swf, id, width, height, flash_version, options = {})
        options.symbolize_keys!

        params = options.delete(:params) || {}
        attributes = options.delete(:attributes) || {}
        flashvars = options.delete(:flashvars) || {}

        attributes[:classid] ||= 'clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'
        attributes[:id] ||= id
        attributes[:name] ||= id

        output_buffer = ActiveSupport::SafeBuffer.new

        if options[:create_div]
          output_buffer << content_tag(:div,
                                       "This website requires <a href='http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash&promoid=BIOW' target='_blank'>Flash player</a> #{flash_version} or higher.",
                                       id: id)
        end

        js = []

        js << "var params = {#{params.to_a.map { |item| "#{item[0]}:'#{item[1]}'" }.join(',')}};"
        js << "var attributes = {#{attributes.to_a.map { |item| "#{item[0]}:'#{item[1]}'" }.join(',')}};"
        js << "var flashvars = {#{flashvars.to_a.map { |item| "#{item[0]}:'#{item[1]}'" }.join(',')}};"

        js << "swfobject.embedSWF('#{swf}', '#{id}', '#{width}', '#{height}', '#{flash_version}', '/swf/expressInstall.swf', flashvars, params, attributes);"

        output_buffer << javascript_tag(js.join)

        output_buffer
      end

      def encode_email(email_address, _options = {})
        email_address = email_address.to_s
        string = ''

        "document.write('#{email_address}');".each_byte do |c|
          string << format('%%%x', c)
        end

        "<script type=\"#{Mime::JS}\">eval(decodeURIComponent('#{string}'))</script>"
      end
    end
  end
end

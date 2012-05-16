module Sunrise
  module Hooks
    module FriendlyId
      module Static
        def should_generate_new_friendly_id?
          base       = send(friendly_id_config.base)
          slug_value = send(friendly_id_config.slug_column)

          # If the slug base is nil, and the slug field is nil, then we're going to leave the slug column NULL.
          return false if base.nil? && slug_value.nil?
          
          # Otherwise, if this is a new record, we're definitely going to try to create a new slug.
          new_record? || slug_value.blank?
        end
      end
    end
  end
end

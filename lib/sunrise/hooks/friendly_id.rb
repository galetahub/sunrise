module Sunrise
  module Hooks
    module FriendlyId
      module Static
        def should_generate_new_friendly_id?
          slug_value = send(friendly_id_config.slug_column)
          new_record? && slug_value.blank?
        end
      end
    end
  end
end

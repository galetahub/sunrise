module Sunrise
  module Hooks
    module FriendlyId
      module Static
        def should_generate_new_friendly_id?
          new_record? && self.try(:slug).blank?
        end
      end
    end
  end
end

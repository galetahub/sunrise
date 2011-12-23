require 'kaminari'

module Sunrise
  module Hooks
    module Kaminari
      extend ActiveSupport::Concern
      
      included do
        include ::Kaminari::ConfigurationMethods

        # Fetch the values at the specified page number
        #   Model.page(5)
        scope :page, Proc.new {|num|
          limit(default_per_page).offset(default_per_page * ([num.to_i, 1].max - 1))
        } do
          include ::Kaminari::ActiveRecordRelationMethods
          include ::Kaminari::PageScopeMethods
        end
      end
    end
  end
end

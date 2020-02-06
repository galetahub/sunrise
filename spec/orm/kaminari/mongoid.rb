# frozen_string_literal: true

require 'kaminari'

module Kaminari
  class Hooks
    def self.init
      begin; require 'mongoid'; rescue LoadError; end
      if defined? ::Mongoid
        require 'kaminari/models/mongoid_extension'
        ::Mongoid::Criteria.include Kaminari::MongoidExtension::Criteria
        ::Mongoid::Document.include Kaminari::MongoidExtension::Document
      end

      require 'kaminari/models/array_extension'

      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.include Kaminari::ActionViewExtension
      end
    end
  end
end

# frozen_string_literal: true

require 'rails-settings-cached'

class Settings < RailsSettings::CachedSettings
  include PublicActivity::Model

  tracked owner: ->(controller, _model) { controller.try(:current_user) }

  def self.update_attributes(attributes)
    attributes.each do |key, value|
      self[key] = value
    end
  end
end

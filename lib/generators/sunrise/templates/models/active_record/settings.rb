# frozen_string_literal: true

require 'rails-settings-cached'

class Settings < RailsSettings::Base
  include PublicActivity::Model

  tracked owner: ->(controller, _model) { controller.try(:current_user) }

  scope :application do
    field :app_name, type: :string, default: 'Rails application'
  end

  def self.update(attributes)
    attributes.each do |key, value|
      self[key] = value
    end
  end

  def self.[](key)
    public_send(key)
  end

  def self.[]=(key, value)
    public_send("#{key}=", value)
  end
end

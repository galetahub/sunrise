class Settings < RailsSettings::CachedSettings
  include PublicActivity::Model

  tracked owner: ->(controller, model) { controller.try(:current_user) }

  def self.update_attributes(attributes)
    attributes.each do |key, value|
      self[key] = value
    end
  end
end 

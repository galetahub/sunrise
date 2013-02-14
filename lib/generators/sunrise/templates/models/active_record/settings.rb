class Settings < ActiveRecord::Base
  include Sunrise::Models::Settings
  include PublicActivity::Model

  tracked owner: ->(controller, model) { controller.try(:current_user) }
end 

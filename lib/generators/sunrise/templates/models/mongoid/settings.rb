class Settings
  include Mongoid::Document
  include Mongoid::Timestamps
  include PublicActivity::Model
  
  # Columns
  field :var, :type => String
  field :value, :type => String
  
  index({var: 1}, {unique: true})

  tracked owner: ->(controller, model) { controller.try(:current_user) }

  def self.table_exists?
    true
  end
end 

class Settings
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunrise::Models::Settings
  
  # Columns
  field :var, :type => String
  field :value, :type => String
  
  index({var: 1}, {unique: true})

  def self.table_exists?
    true
  end
end 

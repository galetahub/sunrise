class Settings < ActiveRecord::Base
  include Sunrise::Models::Settings
  
  attr_accessible :var, :value
end 

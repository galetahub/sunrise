class Role < ActiveRecord::Base
  include Sunrise::Models::Role
  
  attr_accessible :role_type
end

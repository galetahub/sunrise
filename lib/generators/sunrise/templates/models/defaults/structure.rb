class Structure < ActiveRecord::Base
  extend FriendlyId
  include Sunrise::Models::Structure
  
  friendly_id :title, :use => :slugged
  
  attr_accessible :title, :kind, :position, :parent_id, :redirect_url,
                  :position_type, :slug, :parent, :structure_type, 
                  :header_attributes, :is_visible
end

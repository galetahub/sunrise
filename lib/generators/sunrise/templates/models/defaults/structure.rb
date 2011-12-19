class Structure < ActiveRecord::Base
  include Sunrise::Models::Structure
  extend FriendlyId
  
  friendly_id :title, :use => :slugged
  
  attr_accessible :title, :kind, :position, :parent_id, :redirect_url,
                  :position_type, :slug, :parent, :structure_type, 
                  :header_attributes, :is_visible
end

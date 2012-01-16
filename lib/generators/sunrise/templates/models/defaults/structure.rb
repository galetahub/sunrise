class Structure < ActiveRecord::Base
  include Sunrise::Models::Structure

  #acts_as_audited :protect => false  
  #page_parts :main, :sidebar
  
  attr_accessible :title, :kind, :position, :parent_id, :redirect_url,
                  :position_type, :slug, :parent, :structure_type, 
                  :header_attributes, :is_visible, :as => :admin
end

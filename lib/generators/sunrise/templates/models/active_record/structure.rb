class Structure < ActiveRecord::Base
  include Sunrise::Models::Structure
  include PageParts::Extension
  include MetaManager::Taggable

  # audited :protect => false  
  # page_parts :content
  
  attr_accessible :title, :kind, :position, :parent_id, :redirect_url,
                  :position_type, :slug, :parent, :structure_type, :is_visible, :as => :admin
end

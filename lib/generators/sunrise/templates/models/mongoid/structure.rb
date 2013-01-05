class Structure
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunrise::Models::Structure
  include PageParts::Extension
  # include Mongoid::History::Trackable

  # Columns
  field :title, :type => String
  field :slug, :type => String
  field :kind, :type => Integer, :default => 0
  field :position, :type => Integer, :default => 0
  field :is_visible, :type => Boolean, :default => true
  field :redirect_url, :type => String

  index({:kind => 1})
  index({:position => 1})
  index({:parent_id => 1})

  # track_history :on => [:title, :kind, :position, :is_visible]
  # page_parts :content, :sidebar
  
  attr_accessible :title, :kind, :position, :parent_id, :redirect_url,
                  :position_type, :slug, :parent, :structure_type, :is_visible, :as => :admin
end

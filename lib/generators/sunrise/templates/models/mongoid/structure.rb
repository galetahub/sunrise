class Structure
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunrise::Models::Structure
  include PageParts::Extension
  include MetaManager::Taggable
  include PublicActivity::Model

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

  tracked owner: ->(controller, model) { controller.try(:current_user) }
  # page_parts :content, :sidebar
end

# encoding: utf-8
class SunriseStructure < Sunrise::AbstractModel
  self.resource_name = "Structure"
  
  default_list_view :tree
  
  list :tree do    
    field :title
    field :updated_at
    field :id
  end
  
  edit do
    field :title
    field :redirect_url
    field :slug
    #field :headers, :partial => true
    field :parent_id, :collection => [], :if => lambda { |s| s.moveable? }
    field :kind, :collection => StructureType.all, :include_blank => false
    field :position, :collection => PositionType.all, :include_blank => false
    field :is_visible, :boolean => true
  end
end

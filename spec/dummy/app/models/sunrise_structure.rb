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
    field :content, :as => :ckeditor
  end
end

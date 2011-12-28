class SunrisePost < Sunrise::AbstractModel
  self.resource_name = "Post"
  
  association :structure
  
  list :thumbs do    
    field :title
    field :updated_at
    field :id
    
    group :search do
      field :title
      field :structure_id
    end
  end
  
  edit do
    field :title
    field :content
    field :is_visible
  end
end

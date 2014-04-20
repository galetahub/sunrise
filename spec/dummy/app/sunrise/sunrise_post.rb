class SunrisePost < Sunrise::AbstractModel
  self.resource_name = "Post"
  
  association :structure
  
  index :thumbs do
    buttons [:new, :edit, :delete, :sort]

    field :title
    field :updated_at
    field :id
    
    group :search do
      field :title
      field :structure_id
    end
  end
  
  form do
    field :title
    field :content
    field :is_visible
  end
  
  export do
    scope { Post.includes(:structure) }
    
    field :id
    field :title
    field :created_at
    field :structure_title
    field :structure_slug
  end
end

class SunrisePage < Sunrise::AbstractModel
  self.resource_name = "Page"
  
  association :structure, :as => :one
    
  edit do
    field :title
    field :content
  end
end

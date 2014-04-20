class SunrisePage < Sunrise::AbstractModel
  self.resource_name = "Structure"
  
  index false
  
  form do
    field :content, as: :text
    field :sidebar, as: :text
  end
end

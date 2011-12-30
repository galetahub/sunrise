class SunrisePage < Sunrise::AbstractModel
  self.resource_name = "Structure"
  
  list false
  
  edit do
    field :main, :as => :text
    field :sidebar, :as => :text
  end
end

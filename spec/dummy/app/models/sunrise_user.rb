class SunriseUser < Sunrise::AbstractModel
  self.resource_name = "User"
  
  list :thumbs do    
    field :email
    field :updated_at
    field :id
    
    group :search do
      field :email
      field :name
    end
  end
  
  export do
    field :id
    field :name
    field :email
  end
end

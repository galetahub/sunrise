class SunriseUser < Sunrise::AbstractModel
  self.resource_name = "User"
  
  list :table do    
    field :email
    field :updated_at
    field :id
    
    group :search do
      field :email
      field :name
    end
  end

  list :thumbs do    
    scope { User.includes(:avatar) }
    preview { lambda { |user| user.avatar.try(:url, :thumb) } }
    
    field :email, :label => false
    field :updated_at, :label => false
    field :id
    
    group :search do
      field :email
      field :name
    end
  end
  
  edit do
    field :name
    field :email
    field :password
    field :password_confirmation
    field :role_type_id, :collection => lambda { RoleType.all }
    
    group :bottom, :holder => :bottom do
      field :avatar, :as => :uploader
    end
  end
  
  list :export do
    field :id
    field :name
    field :email
  end
end

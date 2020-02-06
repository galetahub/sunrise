# frozen_string_literal: true

class SunriseUser < Sunrise::AbstractModel
  self.resource_name = 'User'

  index :table do
    field :email
    field :updated_at
    field :id

    group :search do
      field :email
      field :name
    end
  end

  index :thumbs do
    scope { User.includes(:avatar) }
    preview ->(user) { user.avatar.try(:url, :thumb) }

    field :email, label: false
    field :updated_at, label: false
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

  form do
    permited_attributes lambda { |user|
      user.admin? ? :all : [:name, :password, :password_confirmation, :avatar_attributes]
    }

    field :name
    field :email
    field :password
    field :password_confirmation
    field :role_type_id, collection: -> { RoleType.all }

    group :bottom, holder: :bottom do
      field :avatar, as: :uploader
    end
  end
end

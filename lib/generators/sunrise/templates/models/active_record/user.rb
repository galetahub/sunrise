class User < ActiveRecord::Base
  include Sunrise::Models::User
  include PublicActivity::Model
  include ActiveModel::ForbiddenAttributesProtection
  
  # Include default devise modules.
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, :encryptor => :sha512

  fileuploads :avatar
  
  tracked owner: ->(controller, model) { controller.try(:current_user) }
end

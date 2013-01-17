class User < ActiveRecord::Base
  include Sunrise::Models::User
  include ActiveModel::ForbiddenAttributesProtection
  
  # Include default devise modules.
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, :encryptor => :sha512

  fileuploads :avatar
  
  # audited :protect => false, :only => [:name, :email, :password]
end

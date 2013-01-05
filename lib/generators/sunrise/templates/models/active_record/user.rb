class User < ActiveRecord::Base
  include Sunrise::Models::User
  
  # Include default devise modules.
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, :encryptor => :sha512

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :email, :password, :password_confirmation, :avatar_attributes, :as => :admin
  
  fileuploads :avatar
  
  # audited :protect => false, :only => [:name, :email, :password]
end

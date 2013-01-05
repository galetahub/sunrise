class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunrise::Models::User
  include Uploader::Fileuploads
  # include Mongoid::History::Trackable
  
  # Columns
  field :name, :type => String, :default => ""
      
  field :email, :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  field :reset_password_token, :type => String
  field :reset_password_sent_at, :type => DateTime
  
  field :remember_created_at, :type => DateTime
      
  field :sign_in_count, :type => Integer, :default => 0
  field :current_sign_in_at, :type => DateTime
  field :last_sign_in_at, :type => DateTime
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip, :type => String

  field :confirmation_token, :type => String
  field :confirmed_at, :type => DateTime
  field :confirmation_sent_at, :type => DateTime
  # field :unconfirmed_email, :type => String # Only if using reconfirmable
  
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  field :unlock_token, :type => String # Only if unlock strategy is :email or :both
  field :locked_at, :type => DateTime
      
  field :password_salt, :type => String
  field :role_type_id, :type => Integer
      
  # Token authenticatable
  # field :authentication_token, :type => String

  # Invitable
  # field :invitation_token, :type => String

  index({:email => 1}, {:unique => true})
  index({:reset_password_token => 1}, {:unique => true})
  index({:confirmation_token => 1}, {:unique => true})
  index({:unlock_token => 1}, {:unique => true})
  index({:role_type_id => 1})

  # Include default devise modules.
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, :encryptor => :sha512

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :email, :password, :password_confirmation, :avatar_attributes, :as => :admin
  
  fileuploads :avatar

  # track_history :on => [:name, :email, :password]
end

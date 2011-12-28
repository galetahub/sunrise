Structure.class_eval do
  has_many :posts, :dependent => :delete_all
end

Structure.class_eval do
  has_many :posts, :dependent => :delete_all
  
  page_parts :main, :sidebar
  
  attr_accessible :main, :sidebar, :as => :admin
end

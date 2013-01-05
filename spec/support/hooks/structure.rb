Structure.class_eval do
  has_many :posts, :dependent => :delete
  
  page_parts :main, :sidebar
  
  attr_accessible :main, :sidebar, :as => :admin
end

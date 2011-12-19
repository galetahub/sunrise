module Sunrise
  module Config
    # Paginate records per page
    mattr_accessor :default_items_per_page
    @@default_items_per_page = 25
    
    # By default show latest first
    mattr_accessor :default_sort_reverse
    @@default_sort_reverse = true
    
    # The display for a model instance (i.e. a single database record).
    mattr_accessor :label_methods
    @@label_methods = [:title, :name]
    
    # Defailt list template view
    mattr_accessor :default_list_view
    @@default_list_view = 'thumbs'
    
    # Find template before rendering
    mattr_accessor :scoped_views
    @@scoped_views = false
    
    def self.scoped_views?
      @@scoped_views === true
    end
  end
end

module Sunrise
  module Config
    autoload :Navigation, 'sunrise/config/navigation'
    
    # Paginate records per page
    mattr_accessor :default_items_per_page
    @@default_items_per_page = 25
    
    # Display audits events (dashboard)
    mattr_accessor :audit_events_per_page
    @@audit_events_per_page = 50
    
    # By default show latest first
    mattr_accessor :default_sort_mode
    @@default_sort_reverse = :desc
    
    # The display for a model instance (i.e. a single database record).
    mattr_accessor :label_methods
    @@label_methods = [:title, :name]
    
    # Defailt list template view
    mattr_accessor :default_list_view
    @@default_list_view = 'thumbs'
    
    mattr_accessor :available_list_view
    @@available_list_view = [:list, :thumbs, :table]
    
    # Defailt list template view
    mattr_accessor :sort_column
    @@sort_column = 'sort_order'
    
    # Find template before rendering
    mattr_accessor :scoped_views
    @@scoped_views = false
    
    # Set available locales in app
    mattr_accessor :available_locales
    @@available_locales = []
    
    def self.scoped_views?
      @@scoped_views === true
    end
    
    def self.nav
      ::SunriseNavigation.instance.navigations
    end
  end
end

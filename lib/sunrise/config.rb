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
    @@default_sort_mode = :desc
    
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
    @@scoped_views = true
    
    # Set available locales in app
    mattr_accessor :available_locales
    @@available_locales = []

    # Set transliteration for babosa gem
    # more info here: https://github.com/norman/babosa
    mattr_accessor :transliteration
    @@transliteration = :russian

    # Set list toolbar buttons
    mattr_accessor :default_toolbar_buttons
    @@default_toolbar_buttons = [:delete, :edit, :new, :sort, :export]
    
    def self.scoped_views?
      @@scoped_views === true
    end
    
    def self.nav
      ::SunriseNavigation.instance.navigations
    end

    def self.audit_scope
      if Object.const_defined?("Audited")
        Audited.audit_class.includes(:user).order("audits.id #{default_sort_mode}")
      else
        HistoryTracker.scoped
      end
    end
  end
end

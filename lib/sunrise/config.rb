# frozen_string_literal: true

module Sunrise
  module Config
    autoload :Navigation, 'sunrise/config/navigation'
    autoload :PagePresenter, 'sunrise/config/page_presenter'

    # Paginate records per page
    mattr_accessor :default_items_per_page
    @@default_items_per_page = 25

    # Display audits events (dashboard)
    mattr_accessor :activities_per_page
    @@activities_per_page = 50

    # By default show latest first
    mattr_accessor :default_sort_mode
    @@default_sort_mode = :desc

    # The display for a model instance (i.e. a single database record).
    mattr_accessor :label_methods
    @@label_methods = [:title, :name]

    # Default index template view
    mattr_accessor :default_index_view
    @@default_index_view = :thumbs

    mattr_accessor :available_index_views
    @@available_index_views = [:tree, :thumbs, :table]

    # Default sort column
    mattr_accessor :sort_column
    @@sort_column = :sort_order

    # Find template before rendering
    mattr_accessor :scoped_views
    @@scoped_views = true

    # Set available locales in app
    mattr_accessor :available_locales
    @@available_locales = []

    # Set index toolbar buttons
    mattr_accessor :default_toolbar_buttons
    @@default_toolbar_buttons = [:delete, :edit, :new, :sort, :export]

    # Index the formats that should be treated as navigational
    mattr_accessor :navigational_formats
    @@navigational_formats = [:html, :json]

    # Welcome root path options
    mattr_accessor :root_route_options
    @@root_route_options = { to: 'manager#index', model_name: 'structures' }

    def self.scoped_views?
      @@scoped_views === true
    end

    def self.navigation
      ::SunriseNavigation.instance.navigations
    end
  end
end

# frozen_string_literal: true

require 'meta_manager/orm/active_record'
require 'page_parts/orm/active_record'

# Use this hook to configure sunrise
Sunrise.setup do |config|
  # Paginate records per page (default: 25)
  # config.default_items_per_page = 25

  # Display audits events on dashboard (default: 50)
  # config.activities_per_page = 50

  # By default show latest first (default: :desc)
  # config.default_sort_mode = :desc

  # The display for a model instance (i.e. a single database record).
  # config.label_methods = [:title, :name]

  # Default list template view (default: "thumbs")
  # config.default_index_view = "thumbs"

  # Avariable lists views (default: [:list, :thumbs, :table])
  # config.available_index_views = [:list, :thumbs, :table]

  # Default sort order column (default: "sort_order")
  # config.sort_column = "sort_order"

  # Find template before rendering (default: true)
  # config.scoped_views = true

  # Set available locales in app (default: [])
  # config.available_locales = []

  # Set list toolbar buttons (default: [:delete, :edit, :new, :sort, :export])
  # config.default_toolbar_buttons = [:delete, :edit, :new, :sort, :export]

  # Lists the formats that should be treated as navigational (default: [:html, :json])
  # config.navigational_formats = [:html, :json]

  # Welcome root path options
  # config.root_route_options = {to: "manager#index", model_name: "structures"}
end

PublicActivity::Config.set do
  orm :active_record
end

# if Settings.table_exists?
#  Settings.some_setting = "value"
#  Settings.some_setting2 = "value2"
# end

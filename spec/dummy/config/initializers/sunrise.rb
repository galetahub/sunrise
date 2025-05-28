# frozen_string_literal: true

require 'simple_form'

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

  # Defailt list template view (default: "thumbs")
  # config.default_list_view = "thumbs"

  # Avariable lists views (default: [:list, :thumbs, :table])
  # config.available_list_view = [:list, :thumbs, :table]

  # Defailt list template view (default: "sort_order")
  # config.sort_column = "sort_order"

  # Find template before rendering (default: true)
  # config.scoped_views = true

  # Set available locales in app (default: [])
  # config.available_locales = []

  # Set transliteration for babosa gem
  # more info here: https://github.com/norman/babosa (default: :russian)
  # config.transliteration = :russian

  # Set list toolbar buttons (default: [:delete, :edit, :new, :sort, :export])
  # config.default_toolbar_buttons = [:delete, :edit, :new, :sort, :export]

  # Lists the formats that should be treated as navigational (default: [:html, :json])
  # config.navigational_formats = [:html, :json]
end

PublicActivity::Config.set do
  orm :active_record
end

# if Settings.table_exists?
#  Settings.defaults[:some_setting] = "value"
#  Settings.defaults[:some_setting2] = "value2"
# end

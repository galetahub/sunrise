# Use this hook to configure sunrise
if Object.const_defined?("Sunrise")
  Sunrise.setup do |config|
    # Flash keys
    #config.flash_keys = [ :success, :failure ]
  end
end

if Settings.table_exists?
  Settings.defaults[:some_setting] = "value"
  Settings.defaults[:some_setting2] = "value2"
end

require "page_parts/orm/#{SUNRISE_ORM}"
require "meta_manager/orm/#{SUNRISE_ORM}"

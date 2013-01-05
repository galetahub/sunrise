# Use this hook to configure sunrise
if Object.const_defined?("Sunrise")
  Sunrise.setup do |config|
    # Flash keys
    #config.flash_keys = [ :success, :failure ]
  end
end

# Assuming HistoryTracker is your tracker class
# Mongoid::History.tracker_class_name = :history_tracker

# Assuming you're using devise/authlogic
# Mongoid::History.current_user_method = :current_user

#if Settings.table_exists?
#  Settings.defaults[:some_setting] = "value"
#  Settings.defaults[:some_setting2] = "value2"
#end

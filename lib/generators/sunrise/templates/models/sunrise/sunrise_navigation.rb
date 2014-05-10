class SunriseNavigation < Sunrise::Config::Navigation
  navigation :main do
    item :structures, index_path(model_name: "structures"), class: "icon2"
    item :users,      index_path(model_name: "users"), class: "icon3"
    item :settings,   edit_settings_path, class: "icon4"
    item :activities, activities_path, class: "icon1"
  end
  
  navigation :creates do
    item :structures, new_path(model_name: "structures")
    item :users,      new_path(model_name: "users")
  end
end

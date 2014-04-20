class SunriseNavigation < Sunrise::Config::Navigation
  navigation :main do
    item :dashboard,  root_path, class: "icon1"
    item :structures, index_path(model_name: "structures"), class: "icon2"
    item :users,      index_path(model_name: "users"), class: "icon3"
    item :settings,   edit_settings_path, class: "icon4"
  end
  
  navigation :creates do
    item :structures, new_path(model_name: "structures")
    item :users,      new_path(model_name: "users")
  end
end

class SunriseNavigation < Sunrise::Config::Navigation
  navigation :main do |m|
    m.item :dashboard,  root_path, :class => "icon1"
    m.item :structures, index_path(:model_name => "structures"), :class => "icon2"
    m.item :users,      index_path(:model_name => "users"), :class => "icon3"
    m.item :services,   "#", :class => "icon4"
    m.item :settings,   "#", :class => "icon4"
  end
  
  navigation :creates do |c|
    c.item :structures, new_path(:model_name => "structures")
    c.item :users,      new_path(:model_name => "users")
  end
end

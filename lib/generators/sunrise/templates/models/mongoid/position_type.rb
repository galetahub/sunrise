# frozen_string_literal: true

class PositionType < Sunrise::Models::PositionType
  define_enum do
    member :default,  object: new('default')
    member :menu,     object: new('menu')
    member :bottom,   object: new('bottom')
  end
end

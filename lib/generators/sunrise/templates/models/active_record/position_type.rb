# frozen_string_literal: true

class PositionType < Sunrise::Models::PositionType
  define_enum do
    member :default
    member :menu
    member :bottom
  end
end

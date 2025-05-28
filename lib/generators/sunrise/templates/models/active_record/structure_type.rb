# frozen_string_literal: true

class StructureType < Sunrise::Models::StructureType
  define_enum do
    member :page
    member :posts
    member :main
    member :redirect
    member :group
  end
end

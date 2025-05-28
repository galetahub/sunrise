# frozen_string_literal: true

class StructureType < Sunrise::Models::StructureType
  define_enum do
    member :page,     object: new('page')
    member :posts,    object: new('posts')
    member :main,     object: new('main')
    member :redirect, object: new('redirect')
    member :group,    object: new('group')
  end
end

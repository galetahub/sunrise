# frozen_string_literal: true

class RoleType < Sunrise::Models::RoleType
  define_enum do
    member :default,   object: new('default')
    member :redactor,  object: new('redactor')
    member :moderator, object: new('moderator')
    member :admin,     object: new('admin')
  end
end

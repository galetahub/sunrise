# frozen_string_literal: true

class RoleType < Sunrise::Models::RoleType
  define_enum do
    member :default
    member :redactor
    member :moderator
    member :admin
  end
end

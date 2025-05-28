# frozen_string_literal: true

FactoryBot.define do
  sequence(:email) { |n| "testing#{n}@example.com" }

  factory :admin_user, class: User do
    name { 'Admin' }
    email { generate(:email) }
    password               { 'password' }
    password_confirmation  { 'password' }
    role_type_id { RoleType.admin.id }

    after(:build) do |u|
      u.skip_confirmation!
    end
  end

  factory :redactor_user, class: User do
    name { 'Redactor' }
    email { generate(:email) }
    password               { 'password' }
    password_confirmation  { 'password' }
    role_type_id { RoleType.redactor.id }

    after(:build) do |u|
      u.skip_confirmation!
    end
  end

  factory :default_user, class: User do
    name { 'Test' }
    email { generate(:email) }
    password               { 'password' }
    password_confirmation  { 'password' }
    role_type_id { RoleType.default.id }

    after(:build) do |u|
      u.skip_confirmation!
    end
  end

  factory :user, class: User do
    name { 'Test' }
    email { generate(:email) }
    password               { 'password' }
    password_confirmation  { 'password' }
  end
end

# encoding: utf-8
FactoryGirl.define do
  factory :admin_user, :class => User do
    name 'Admin'
    email { FactoryGirl.generate(:email) }
    password               'password'
    password_confirmation  'password'
    
    after(:build) do |u| 
      u.roles.build(:role_type => RoleType.admin)
      u.skip_confirmation!
    end
  end

  factory :redactor_user, :class => User do
    name 'Redactor'
    email { FactoryGirl.generate(:email) }
    password               'password'
    password_confirmation  'password'
    
    after(:build) do |u| 
      u.roles.build(:role_type => RoleType.redactor)
      u.skip_confirmation!
    end
  end

  factory :default_user, :class => User do
    name 'Test'
    email { FactoryGirl.generate(:email) }
    password               'password'
    password_confirmation  'password'
    
    after(:build) do |u| 
      u.roles.build(:role_type => RoleType.default)
      u.skip_confirmation!
    end
  end

  factory :user, :class => User do
    name 'Test'
    email { FactoryGirl.generate(:email) }
    password               'password'
    password_confirmation  'password'
  end
  
  sequence :email do |n|
    "testing#{n}@example.com"
  end
end

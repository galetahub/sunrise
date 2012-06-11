# encoding: utf-8
FactoryGirl.define do
  factory :admin_user, :class => User do |user|
    user.name 'Admin'
    user.email { FactoryGirl.generate(:email) }
    user.password               'password'
    user.password_confirmation  'password'
    
    user.after(:build) do |u| 
      u.roles.build(:role_type => RoleType.admin)
      u.skip_confirmation!
    end
  end

  factory :redactor_user, :class => User do |user|
    user.name 'Redactor'
    user.email { FactoryGirl.generate(:email) }
    user.password               'password'
    user.password_confirmation  'password'
    
    user.after(:build) do |u| 
      u.roles.build(:role_type => RoleType.redactor)
      u.skip_confirmation!
    end
  end

  factory :moderator_user, :class => User do |user|
    user.name 'Redactor'
    user.email { FactoryGirl.generate(:email) }
    user.password               'password'
    user.password_confirmation  'password'
    
    user.after(:build) do |u| 
      u.roles.build(:role_type => RoleType.moderator)
      u.skip_confirmation!
    end
  end

  factory :default_user, :class => User do |user|
    user.name 'Test'
    user.email { FactoryGirl.generate(:email) }
    user.password               'password'
    user.password_confirmation  'password'
    
    user.after(:build) do |u| 
      u.roles.build(:role_type => RoleType.default)
      u.skip_confirmation!
    end
  end

  factory :user, :class => User do |user|
    user.name 'Test'
    user.email { FactoryGirl.generate(:email) }
    user.password               'password'
    user.password_confirmation  'password'
  end

  sequence :email do |n|
    "testing#{n}@example.com"
  end
end

# encoding: utf-8
FactoryGirl.define do
  factory :audit, :class => Audit do |a|
    a.action "create"
    a.audited_changes :title => "Updated"
    a.association :user, :factory => :default_user
    a.association :auditable, :factory => :post
  end
end

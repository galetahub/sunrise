# encoding: utf-8
if Object.const_defined?("Audited")
  FactoryGirl.define do
    factory :audit, :class => Audited.audit_class do |a|
      a.action "create"
      a.audited_changes :title => "Updated"
      a.association :user, :factory => :default_user
      a.association :auditable, :factory => :post
    end
  end
else
  FactoryGirl.define do
    factory :audit, :class => HistoryTracker do
      action "create"
      modified :title => "Updated"
      original :title => "original"
      version 1

      after(:build) do |a| 
        a.trackable = FactoryGirl.create(:post)
      end
    end
  end
end
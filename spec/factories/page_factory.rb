# encoding: utf-8
if Object.const_defined?("PagePart")
  FactoryGirl.define do
    factory :page, :class => PagePart do |p|
      p.key "main"
      p.content "Test content"
      p.association :partable, :factory => :structure_page
    end
  end
end
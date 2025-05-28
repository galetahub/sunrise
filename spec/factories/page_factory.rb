# frozen_string_literal: true

if Object.const_defined?('PagePart')
  FactoryBot.define do
    factory :page, class: PagePart do |p|
      p.key 'main'
      p.content 'Test content'
      p.association :partable, factory: :structure_page
    end
  end
end

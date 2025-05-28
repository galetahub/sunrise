# frozen_string_literal: true

if Object.const_defined?('PagePart')
  FactoryBot.define do
    factory :page, class: PagePart do
      key { 'main' }
      content { 'Test content' }

      association :partable, factory: :structure_page
    end
  end
end

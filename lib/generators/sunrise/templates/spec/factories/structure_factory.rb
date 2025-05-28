# frozen_string_literal: true

FactoryBot.define do
  factory :structure_page, class: Structure do
    title 'Structure'
    slug { FactoryBot.generate(:slug) }
    structure_type StructureType.page
    position_type PositionType.menu
    is_visible true
  end

  factory :structure_main, class: Structure do
    title 'Main page'
    slug 'main-page'
    structure_type StructureType.main
    position_type PositionType.default
    is_visible true
  end

  sequence :slug do |n|
    "slug#{n}"
  end
end

# encoding: utf-8
FactoryGirl.define do
  factory :structure_page, :class => Structure do |s|
    s.title 'Structure'
    s.slug { FactoryGirl.generate(:slug) }
    s.structure_type StructureType.page
    s.position_type PositionType.menu
    s.is_visible true
  end

  factory :structure_main, :class => Structure do |s|
    s.title "Main page"
    s.slug "main-page"
    s.structure_type StructureType.main
    s.position_type PositionType.default
    s.is_visible true
  end

  sequence :slug do |n|
    "slug#{n}"
  end
end

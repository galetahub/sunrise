# frozen_string_literal: true

FactoryBot.define do
  factory :post, class: Post do
    title { 'Default title' }
    content { 'Some post content' }
    is_visible { true }

    association :structure, factory: :structure_page
  end
end

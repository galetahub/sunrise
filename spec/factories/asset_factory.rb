# frozen_string_literal: true

FactoryBot.define do
  factory :asset_avatar, class: Avatar do
    # include ActionDispatch::TestProcess
    data { File.open('spec/factories/files/rails.png') }
    association :assetable, factory: :default_user

    before(:create) do |instance|
      instance.data_content_type ||= 'image/png'
    end
  end

  factory :asset_avatar_big, class: Avatar do
    data { File.open('spec/factories/files/silicon_valley.jpg') }
    association :assetable, factory: :default_user

    before(:create) do |instance|
      instance.data_content_type ||= 'image/jpg'
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'
require 'carrierwave/test/matchers'

describe Avatar do
  include CarrierWave::Test::Matchers

  before(:each) do
    CarrierWave.root = Rails.root.join(Rails.public_path).to_s

    AvatarUploader.enable_processing = false
    @avatar = FactoryBot.build(:asset_avatar, data_content_type: 'image/png')
  end

  after(:each) do
    AvatarUploader.enable_processing = false
    @avatar.destroy if @avatar
  end

  it 'should create a new instance given valid attributes' do
    @avatar.save!
  end

  context 'validations' do
    it 'should not be valid without data' do
      @avatar.data = nil
      expect(@avatar).not_to be_valid
    end

    it 'should not be valid with not image content-type' do
      @avatar.data_content_type = 'unknown type'
      expect(@avatar).not_to be_valid
    end
  end

  context 'after create' do
    before(:each) do
      @avatar.save!
    end

    it 'filename should be valid' do
      expect(@avatar.filename).to eq 'rails.png'
    end

    it 'content-type should be valid' do
      expect(@avatar.data_content_type).to eq 'image/png'
    end

    it 'should be image' do
      expect(@avatar.image?).to be_truthy
    end

    it 'data_file_name should be valid' do
      @avatar.data_file_name.should == 'rails.png'
    end

    it 'urls should be valid' do
      expect(@avatar.data.default_url).to eq '/assets/defaults/avatar.png'
      expect(@avatar.thumb_url).to eq "/uploads/#{@avatar.class.to_s.underscore}/#{@avatar.id}/thumb_rails.png"
      expect(@avatar.url).to eq "/uploads/#{@avatar.class.to_s.underscore}/#{@avatar.id}/rails.png"
    end
  end

  context 'cropping' do
    before(:each) do
      @avatar.save!
      @avatar.cropper_geometry = '50,64,10,10'
    end

    it 'should construct cropping geometry' do
      expect(@avatar.cropper_geometry).to eq %w[50 64 10 10]
      expect(@avatar.cropper_geometry_changed?).to eq true
    end
  end

  context 'rotate' do
    before(:each) do
      @avatar.save
      @avatar.rotate_degrees = '-90'
    end

    it 'should set property correctly' do
      expect(@avatar.rotate_degrees).to eq '-90'
      expect(@avatar.rotate_degrees_changed?).to eq true
    end
  end
end

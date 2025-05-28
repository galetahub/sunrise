# frozen_string_literal: true

require 'spec_helper'
require 'carrierwave/test/matchers'

describe PictureUploader do
  include CarrierWave::Test::Matchers

  before do
    PictureUploader.enable_processing = false
    @avatar = FactoryBot.build(:asset_avatar, data: nil)
    @uploader = PictureUploader.new(@avatar, :data)
    @uploader.store!(File.open('spec/factories/files/rails.png'))
  end

  after do
    PictureUploader.enable_processing = false
  end

  context 'the thumb version' do
    it 'should scale down a landscape image to be exactly 100 by 100 pixels' do
      expect(@uploader.thumb).to have_dimensions(50, 50)
    end
  end

  context 'manipulation' do
    it 'should strip image' do
      expect {
        @uploader.strip
      }.not_to raise_error
    end

    it 'should set image quality' do
      expect {
        @uploader.quality(80)
      }.not_to raise_error
    end

    it 'should rotate image' do
      expect {
        @uploader.rotate(90)
      }.not_to raise_error
    end

    it 'should crop image' do
      expect {
        @uploader.cropper(['50x60', '+5+5'])
      }.not_to raise_error
    end
  end
end

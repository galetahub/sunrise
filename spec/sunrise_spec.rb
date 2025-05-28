# frozen_string_literal: true

require 'spec_helper'

describe Sunrise do
  it 'should be valid' do
    Sunrise.should be_a(Module)
  end

  it 'should return valid root path' do
    File.exist?(Sunrise.root_path).should be true
  end

  context 'configuration' do
    before(:each) do
      Sunrise.setup do |c|
        c.default_items_per_page = 50
        c.default_sort_mode = :asc
        c.default_index_view = :table
        c.scoped_views = true
      end
    end

    it 'should store configuration' do
      expect(Sunrise::Config.default_items_per_page).to eq 50
      expect(Sunrise::Config.default_sort_mode).to eq:asc
      expect(Sunrise::Config.default_index_view).to eq :table
      expect(Sunrise::Config.scoped_views).to eq true
    end
  end
end

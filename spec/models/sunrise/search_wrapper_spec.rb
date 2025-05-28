# frozen_string_literal: true

require 'spec_helper'

describe Sunrise::Views::SearchWrapper do
  before(:each) { @search = Sunrise::Views::SearchWrapper.new(title: 'Some title', monkey: 'green') }

  it 'should generate attrs methods' do
    expect(@search.title).to eq 'Some title'
  expect(@search.monkey).to eq 'green'
  end

  it 'should return empty key' do
    expect(@search.to_key).to be_nil
    expect(@search.to_model).to be_nil
  end

  it 'should return model name' do
    expect(Sunrise::Views::SearchWrapper.model_name.plural).to eq 'searches'
    expect(Sunrise::Views::SearchWrapper.model_name.singular).to eq 'search'
    expect(Sunrise::Views::SearchWrapper.model_name.param_key).to eq 'search'
  end
end

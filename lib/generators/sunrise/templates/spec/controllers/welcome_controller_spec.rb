# frozen_string_literal: true

require 'spec_helper'

describe WelcomeController, type: :controller do
  render_views

  before(:each) do
    @root = FactoryBot.create(:structure_main)
  end

  it 'should render index action' do
    get :index

    assigns(:structure).should == @root

    response.should be_success
    response.should render_template('index')
  end
end

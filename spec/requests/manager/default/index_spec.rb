# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Index' do
  subject { page }
  before(:all) do
    @admin = FactoryBot.create(:admin_user)
    @root = FactoryBot.create(:structure_main)
    @page = FactoryBot.create(:structure_page, parent: @root)
  end

  context 'admin' do
    before(:each) { login_as @admin }

    describe 'GET /manage' do
      it 'should respond successfully' do
        visit root_path
      end
    end

    describe 'GET /manage/typo' do
      it 'should raise NotFound' do
        expect {
          visit '/manage/whatever'
        }.to raise_error ActionController::RoutingError
      end
    end

    describe 'GET /manage/structures' do
      before(:each) do
        visit index_path(model_name: 'structures')
      end

      it 'should show page title' do
        should have_content(@page.title)
      end
    end

    describe 'GET /manage/users' do
      before(:each) do
        Sunrise::Config.scoped_views = true
        visit index_path(model_name: 'users')
      end

      it 'should render inherit user templace' do
        should have_content('UserTestSection')
      end
    end

    describe 'GET /manage/pages' do
      it 'should render 404 page' do
        expect {
          visit index_path(model_name: 'pages')
        }.to raise_error AbstractController::ActionNotFound
      end
    end
  end

  describe 'anonymous user' do
    before(:each) do
      visit index_path(model_name: 'structures')
    end

    it 'should redirect to login page' do
      should have_content('Sign in')
    end
  end
end

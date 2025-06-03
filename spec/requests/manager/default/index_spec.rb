# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Index' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'GET /manage' do
      it 'should respond successfully' do
        visit root_path
      end
    end

    describe 'GET /manage/typo' do
      it 'should raise NotFound' do
        visit '/manage/whatever'
        expect(page.body).to include('Sunrise model whatever not found')
      end
    end

    describe 'GET /manage/structures' do
      before(:each) do
        visit index_path(model_name: 'structures')
      end

      it 'should show page title' do
        should have_content(structure.title)
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
        visit index_path(model_name: 'pages')
        expect(page.body).to include('Unknown action')
      end
    end
  end

  describe 'anonymous user' do
    it 'should redirect to login page' do
      visit index_path(model_name: 'structures')
      should have_content('Sign in')
    end
  end
end

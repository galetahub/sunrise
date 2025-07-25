# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Edit' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }

  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }

  it 'should be moveable page' do
    expect(structure).to be_moveable
  end

  context 'admin' do
    before(:each) { login_as admin }

    describe 'GET /manage/notexists/edit' do
      it 'should raise NotFound' do
        visit edit_path(model_name: 'whatever', id: structure.id)
        expect(page.body).to include('Sunrise model whatever not found')
      end
    end

    describe 'GET /manage/structures/:id/edit' do
      before(:each) do
        visit edit_path(model_name: 'structures', id: structure.id)
      end

      it 'should show page title' do
        should have_content(I18n.t('manage.edit'))
      end

      it 'should generate field to edit' do
        should have_selector "input[@name='structure[title]']"
        should have_selector "input[@name='structure[redirect_url]']"
        should have_selector "input[@name='structure[slug]']"
        should have_selector '#structure_parent_id'
        should have_selector '#structure_structure_type_id'
        should have_selector '#structure_position_type_id'
        should have_selector "input[@name='structure[is_visible]']"
      end
    end

    describe 'GET /manage/pages/:id/edit' do
      before(:each) do
        visit edit_path(model_name: 'pages', id: structure.id)
      end

      it 'should show page title' do
        should have_content(I18n.t('manage.edit'))
      end

      it 'should generate field to edit' do
        should have_selector "textarea[@name='structure[content]']"
        should have_selector "textarea[@name='structure[sidebar]']"
      end
    end
  end

  describe 'anonymous user' do
    it 'should redirect to login page' do
      visit edit_path(model_name: 'structures', id: structure.id)
      should have_content('Sign in')
    end
  end
end

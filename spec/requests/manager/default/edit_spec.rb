# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Edit' do
  subject { page }
  before(:all) do
    @admin = FactoryGirl.create(:admin_user)

    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, parent: @root)
  end

  it 'should be moveable page' do
    @page.should be_moveable
  end

  context 'admin' do
    before(:each) { login_as @admin }

    describe 'GET /manage/typo/edit' do
      it 'should raise NotFound' do
        lambda {
          visit edit_path(model_name: 'whatever', id: @page.id)
        }.should raise_error ActionController::RoutingError
      end
    end

    describe 'GET /manage/structures/:id/edit' do
      before(:each) do
        visit edit_path(model_name: 'structures', id: @page.id)
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
        visit edit_path(model_name: 'pages', id: @page.id)
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
    before(:each) do
      visit edit_path(model_name: 'structures', id: @page.id)
    end

    it 'should redirect to login page' do
      should have_content('Sign in')
    end
  end
end

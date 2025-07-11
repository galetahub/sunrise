# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager New' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'GET /manage/typo/new' do
      it 'should raise NotFound' do
        visit new_path(model_name: 'whatever')
        expect(page.body).to include('Sunrise model whatever not found')
      end
    end

    describe 'GET /manage/structures/new' do
      before(:each) do
        visit new_path(model_name: 'structures')
      end

      it 'should show page title' do
        should have_content(I18n.t('manage.add'))
      end

      it 'should generate field to edit' do
        SunriseStructure.config.form.fields.each do |f|
          if %w[structure_type_id parent_id position_type_id].include?(f.name)
            should have_selector "select[@name='structure[#{f.name}]']"
          else
            should have_selector "input[@name='structure[#{f.name}]']"
          end
        end
      end
    end

    describe 'GET /manage/structures/new with params' do
      let(:title) { 'some-title' }

      it 'should pre-fill attributes' do
        visit new_path(model_name: 'structures', structure: { title: title })
        should have_selector "input[@value='#{title}']"
      end
    end
  end

  describe 'anonymous user' do
    it 'should redirect to login page' do
      visit new_path(model_name: 'structures')
      should have_content('Sign in')
    end
  end
end

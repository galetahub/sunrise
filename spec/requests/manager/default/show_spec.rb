# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager New' do
  subject { page }
  before(:all) do
    @admin = FactoryBot.create(:admin_user)

    @root = FactoryBot.create(:structure_main)
    @page = FactoryBot.create(:structure_page, parent: @root)
  end

  context 'admin' do
    before(:each) { login_as @admin }

    describe 'GET /manage/structures/1' do
      before(:each) do
        visit show_path(model_name: 'structures', id: @page.id)
      end

      it 'should show page title' do
        should have_content(@page.title)
      end

      it 'should display configured fields to show' do
        SunriseStructure.config.show.fields.each do |f|
          should have_content f.human_name
        end
      end
    end
  end

  describe 'anonymous user' do
    before(:each) do
      visit show_path(model_name: 'structures', id: @page.id)
    end

    it 'should redirect to login page' do
      should have_content('Sign in')
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager New' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'GET /manage/structures/1' do
      before(:each) do
        visit show_path(model_name: 'structures', id: structure.id)
      end

      it 'should show page title' do
        should have_content(structure.title)
      end

      it 'should display configured fields to show' do
        SunriseStructure.config.show.fields.each do |f|
          should have_content f.human_name
        end
      end
    end
  end

  describe 'anonymous user' do
    it 'should redirect to login page' do
      visit show_path(model_name: 'structures', id: structure.id)
      should have_content('Sign in')
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager New' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'create' do
      let(:structure) { Structure.last }
      let(:new_title) { 'Title updated' }

      before(:each) do
        visit new_path(model_name: 'structures')

        within("#resource-manage-form") do
          fill_in 'structure_title', with: new_title
          select(StructureType.page.title, from: 'structure[structure_type_id]')
          select(PositionType.menu.title, from: 'structure[position_type_id]')
          check('structure[is_visible]')
        end

        click_button 'Create'
      end

      it 'should create an object with correct attributes' do
        expect(structure).not_to be_nil
        expect(structure.title).to eq new_title
        expect(structure.structure_type).to eq StructureType.page
        expect(structure.position_type).to eq PositionType.menu
        expect(structure.is_visible).to eq true
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

# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager New' do
  subject { page }
  before(:all) { @admin = FactoryGirl.create(:admin_user) }

  context 'admin' do
    before(:each) { login_as @admin }

    describe 'create' do
      before(:each) do
        visit new_path(model_name: 'structures')

        fill_in 'structure[title]', with: 'Good day'
        select(StructureType.page.title, from: 'structure[structure_type_id]')
        select(PositionType.menu.title, from: 'structure[position_type_id]')
        check('structure[is_visible]')

        click_button 'submit-button-hidden'

        @structure = Structure.last
      end

      it 'should create an object with correct attributes' do
        @structure.should_not be_nil
        @structure.title.should == 'Good day'
        @structure.structure_type.should == StructureType.page
        @structure.position_type.should == PositionType.menu
        @structure.is_visible.should == true
      end
    end
  end

  describe 'anonymous user' do
    before(:each) do
      visit new_path(model_name: 'structures')
    end

    it 'should redirect to login page' do
      should have_content('Sign in')
    end
  end
end

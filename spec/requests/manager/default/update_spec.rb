# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Edit' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'update' do
      before(:each) do
        visit edit_path(model_name: 'structures', id: structure.id)

        fill_in 'structure[title]', with: 'Title updated'
        select(StructureType.posts.title, from: 'structure_structure_type_id')
        select(PositionType.default.title, from: 'structure_position_type_id')
        uncheck('structure[is_visible]')

        click_button 'submit-form-button'
      end

      it 'should update an object with correct attributes' do
        structure.reload

        expect(structure.title).to eq 'Title updated'
        expect(structure.structure_type).to eq StructureType.posts
        expect(structure.position_type).to eq PositionType.default
        expect(structure.is_visible).to eq false
      end

      it 'should redirect with model_name' do
        page.current_path.should == '/manage/structures'
      end
    end

    describe 'Update /manage/pages/:id/edit' do
      before(:each) do
        structure.update(content: 'Main', sidebar: 'Sidebar')

        visit edit_path(model_name: 'pages', id: structure.id)

        fill_in 'structure[content]', with: 'Main updated'
        fill_in 'structure[sidebar]', with: 'Sidebar updated'

        click_button 'submit-form-button'
      end

      it 'should update an object with correct attributes' do
        structure.reload

        expect(structure.content).to eq 'Main updated'
        expect(structure.sidebar).to eq 'Sidebar updated'
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

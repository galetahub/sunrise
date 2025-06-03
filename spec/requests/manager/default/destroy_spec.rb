# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager destroy' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let!(:structure) { FactoryBot.create(:structure_page, parent: root) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'destroy' do
      before(:each) do
        visit index_path(model_name: 'structures')
        click_link "delete_structure_#{structure.id}"
      end

      it 'should update an object with correct attributes' do
        expect(Structure.where(id: structure.id).first).to be_nil
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

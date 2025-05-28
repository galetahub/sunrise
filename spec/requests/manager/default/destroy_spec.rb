# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager destroy' do
  subject { page }
  before(:all) do
    @admin = FactoryBot.create(:admin_user)

    @root = FactoryBot.create(:structure_main)
    @page = FactoryBot.create(:structure_page, parent: @root)
  end

  context 'admin' do
    before(:each) { login_as @admin }

    describe 'destroy' do
      before(:each) do
        visit index_path(model_name: 'structures')
        click_link "delete_structure_#{@page.id}"
      end

      it 'should update an object with correct attributes' do
        expect(Structure.where(id: @page.id).first).to be_nil
      end
    end
  end

  describe 'anonymous user' do
    before(:each) do
      visit index_path(model_name: 'structures')
    end

    it 'should redirect to login page' do
      should have_content('Sign in')
    end
  end
end

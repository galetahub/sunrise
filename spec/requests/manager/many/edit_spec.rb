# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Edit many' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }
  let(:post) { FactoryBot.create(:post, structure: structure) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'GET /manage/posts/:id/edit' do
      before(:each) do
        visit edit_path(model_name: 'posts', id: post.id, parent_id: structure.id, parent_type: structure.class.name)
      end

      it 'should show page title' do
        should have_content(I18n.t('manage.edit'))
      end

      it 'should generate field to edit' do
        should have_selector "input[@name='post[title]']"
        should have_selector "input[@name='post[is_visible]']"
        should have_selector "textarea[@name='post[content]']"
      end
    end
  end

  describe 'anonymous user' do
    it 'should redirect to login page' do
      visit edit_path(model_name: 'posts', id: post.id, parent_id: structure.id, parent_type: structure.class.name)
      should have_content('Sign in')
    end
  end
end

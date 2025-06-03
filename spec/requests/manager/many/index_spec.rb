# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Index many' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }
  let(:post) { FactoryBot.create(:post, structure: structure) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'GET /manage/posts' do
      before(:each) do
        visit index_path(model_name: 'posts', parent_id: structure.id, parent_type: structure.class.name)
      end

      it 'should render records' do
        should have_selector("#post_#{post.id}")
      end
    end

    describe 'search' do
      let(:post2) { FactoryBot.create(:post, title: 'Good day', structure: structure) }
      before(:each) do
        visit index_path(model_name: 'posts', parent_id: structure.id, parent_type: structure.class.name)

        fill_in 'search[title]', with: 'Good day'

        click_button 'submit-button-search'
      end

      it 'should find post' do
        should have_selector("#post_#{post2.id}")
        should_not have_selector("#post_#{post.id}")
      end
    end

    describe 'GET /manage/posts' do
      it 'should not render records' do
        visit index_path(model_name: 'posts', parent_id: root.id, parent_type: root.class.name)
        should_not have_selector("#post_#{post.id}")
      end
    end
  end
end

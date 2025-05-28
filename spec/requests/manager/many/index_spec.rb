# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Index many' do
  subject { page }
  before(:all) do
    @admin = FactoryBot.create(:admin_user)

    @root = FactoryBot.create(:structure_main)
    @page = FactoryBot.create(:structure_page, parent: @root)

    @post = FactoryBot.create(:post, structure: @page)
  end

  context 'admin' do
    before(:each) { login_as @admin }

    describe 'GET /manage/posts' do
      before(:each) do
        visit index_path(model_name: 'posts', parent_id: @page.id, parent_type: @page.class.name)
      end

      it 'should render records' do
        should have_selector("#post_#{@post.id}")
      end
    end

    describe 'search' do
      before(:each) do
        @post2 = FactoryBot.create(:post, title: 'Good day', structure: @page)

        visit index_path(model_name: 'posts', parent_id: @page.id, parent_type: @page.class.name)

        fill_in 'search[title]', with: 'Good day'

        click_button 'submit-button-search'
      end

      it 'should find post' do
        should have_selector("#post_#{@post2.id}")
        should_not have_selector("#post_#{@post.id}")
      end
    end

    describe 'GET /manage/posts' do
      before(:each) do
        visit index_path(model_name: 'posts', parent_id: @root.id, parent_type: @root.class.name)
      end

      it 'should not render records' do
        should_not have_selector("#post_#{@post.id}")
      end
    end
  end
end

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

    describe 'update' do
      before(:each) do
        visit edit_path(model_name: 'posts', id: post.id, parent_id: structure.id, parent_type: structure.class.name)

        # save_and_open_page

        fill_in 'post[title]', with: 'Title updated'
        fill_in 'post[content]', with: 'Tra la la'
        uncheck('post[is_visible]')

        click_button 'submit-form-button'
      end

      it 'should update an object with correct attributes' do
        post.reload

        expect(post.title).to eq 'Title updated'
        expect(post.content).to eq 'Tra la la'
        expect(post.structure).to eq structure
        expect(post.is_visible).to eq false
      end

      it 'should redirect with association params' do
        expect(page.current_path).to eq '/manage/posts'
        expect(page.current_url).to eq "http://www.example.com/manage/posts?parent_id=#{structure.id}&parent_type=#{structure.class.name.downcase}"
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

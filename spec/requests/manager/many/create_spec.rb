# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager New' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }

  context 'admin' do
    before(:each) { login_as admin }
    let(:post) { Post.last }

    describe 'create' do
      before(:each) do
        visit new_path(model_name: 'posts', parent_id: structure.id, parent_type: structure.class.name)

        fill_in 'post[title]', with: 'Good title'
        fill_in 'post[content]', with: 'Some long text' * 10
        check('post[is_visible]')

        click_button 'Create'
      end

      it 'should create an object with correct attributes' do
        expect(post).not_to be_nil
        expect(post.title).to eq 'Good title'
        expect(post.content).not_to be_blank
        expect(post.is_visible).to eq true
        expect(post.structure).to eq structure
      end

      it 'should redirect with association params' do
        expect(page.current_path).to eq '/manage/posts'
        expect(page.current_url).to eq "http://www.example.com/manage/posts?parent_id=#{structure.id}&parent_type=#{structure.class.name}"
      end
    end
  end

  describe 'anonymous user' do
    before(:each) do
      visit new_path(model_name: 'posts')
    end

    it 'should redirect to login page' do
      should have_content('Sign in')
    end
  end
end

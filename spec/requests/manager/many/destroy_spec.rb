# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager destroy' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }
  let(:post) { FactoryBot.create(:post, structure: structure) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'destroy' do
      before(:each) do
        visit index_path(model_name: 'posts', parent_id: structure.id, parent_type: structure.class.name)
        click_link "delete_post_#{post.id}"
      end

      it 'should update an object with correct attributes' do
        Post.where(id: post.id).first.should be_nil

        expect(page.current_path).to eq '/manage/posts'
        expect(page.current_url).to eq "http://www.example.com/manage/posts?parent_id=#{structure.id}&parent_type=#{structure.class.name}"
      end
    end
  end

  describe 'anonymous user' do
    it 'should redirect to login page' do
      visit index_path(model_name: 'posts', parent_id: structure.id, parent_type: structure.class.name)
      should have_content('Sign in')
    end
  end
end

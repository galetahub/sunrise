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

        page.current_path.should == '/manage/posts'
        page.current_url.should == "http://www.example.com/manage/posts?parent_id=#{structure.id}&parent_type=#{structure.class.name}"
      end
    end
  end

  describe 'anonymous user' do
    before(:each) do
      visit index_path(model_name: 'posts', parent_id: structure.id, parent_type: structure.class.name)
    end

    it 'should redirect to login page' do
      should have_content('Sign in')
    end
  end
end

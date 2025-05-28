# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager New' do
  subject { page }
  before(:all) do
    @admin = FactoryBot.create(:admin_user)

    @root = FactoryBot.create(:structure_main)
    @page = FactoryBot.create(:structure_page, parent: @root)
  end

  context 'admin' do
    before(:each) { login_as @admin }

    describe 'create' do
      before(:each) do
        visit new_path(model_name: 'posts', parent_id: @page.id, parent_type: @page.class.name)

        fill_in 'post[title]', with: 'Good title'
        fill_in 'post[content]', with: 'Some long text' * 10
        check('post[is_visible]')

        click_button 'submit-button-hidden'

        @post = Post.last
      end

      it 'should create an object with correct attributes' do
        expect(@post).not_to be_nil
        expect(@post.title).to eq 'Good title'
        expect(@post.content).not_to be_blank
        expect(@post.is_visible).to eq true
        expect(@post.structure).to eq @page
      end

      it 'should redirect with association params' do
        expect(page.current_path).to eq '/manage/posts'
        expect(page.current_url).to eq "http://www.example.com/manage/posts?parent_id=#{@page.id}&parent_type=#{@page.class.name}"
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

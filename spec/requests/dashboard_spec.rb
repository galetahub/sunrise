# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Dashboard' do
  subject { page }
  before(:all) do
    @admin = FactoryBot.create(:admin_user, email: "#{Time.now.to_i}@gmail.com")

    @post = FactoryBot.create(:post)
    @user = FactoryBot.create(:redactor_user)
  end

  context 'admin' do
    before(:each) { login_as @admin }

    describe 'GET /manage' do
      before(:each) do
        visit dashboard_path
      end

      it 'should show page title' do
        should have_content 'Dashboard'
      end
    end
  end

  describe 'anonymous user' do
    it 'should redirect to login page' do
      visit dashboard_path
      should have_content('Sign in')
    end
  end
end

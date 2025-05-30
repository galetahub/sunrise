# frozen_string_literal: true

require 'spec_helper'

describe User do
  let(:user) { FactoryBot.build(:default_user) }

  it 'should create a new instance given valid attributes' do
    user.save!
  end

  context 'validations' do
    it 'should not be valid with empty name' do
      user.name = nil
      expect(user).not_to be_valid
    end

    it 'should not be valid with empty email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'should not be valid with invalid email' do
      user.email = 'wrong'
      expect(user).not_to be_valid
    end

    it 'should not be valid with invalid password' do
      user.password = '123'
      expect(user).not_to be_valid
    end
  end

  context 'after create' do
    let!(:user) { FactoryBot.create(:default_user) }

    it 'should search users by email' do
      # TODO: not working in mongoid
      # User.with_email(@user.email.split(/@/).first).first.should == @user
      expect(User.with_email(user.email).first.id).to eq user.id
    end

    it 'should search users by role' do
      expect(User.with_role(::RoleType.default)).to include(user)
    end

    it 'export users in csv format' do
      User.to_csv.should include([user.id, user.email, user.name, user.current_sign_in_ip].join(','))
    end

    it 'export users in csv format with custom columns' do
      options = { columns: [:id, :email, :confirmed_at, :created_at] }
      User.to_csv(options).should include([user.id, user.email, user.confirmed_at, user.created_at].join(','))
    end

    it 'should set default role' do
      expect(user.role_type).to eq RoleType.default
      expect(user.role_type_id).to eq RoleType.default.id
      expect(user.role_symbol).to eq RoleType.default.name
    end
  end
end

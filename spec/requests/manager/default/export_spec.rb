# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager Export' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }

  context 'admin' do
    before(:each) do
      login_as admin
    end

    describe 'GET /manage/users/export.xlsx' do
      before(:each) do
        visit export_path(model_name: 'users', format: :xlsx)
      end

      it 'should send excel file with users' do
        headers = page.response_headers

        expect(headers['Content-Type']).to eq 'application/vnd.ms-excel'
        expect(headers['Content-Disposition']).to eq 'attachment; filename="users_2012-01-01_16h00m00.xls"'
      end
    end

    describe 'GET /manage/users/export.csv' do
      before(:each) do
        visit export_path(model_name: 'users', format: :csv)
      end

      it 'should send csv file with users' do
        headers = page.response_headers

        expect(headers['Content-Type']).to eq 'text/csv'
        expect(headers['Content-Disposition']).to eq 'attachment; filename="users_2012-01-01_16h00m00.csv"'

        expect(page.status_code).to eq 200
        expect(page.body).not_to be_blank
        expect(page.body).to include(admin.email)
      end
    end

    describe 'GET /manage/users/export.json' do
      before(:each) do
        visit export_path(model_name: 'users', format: :json)
      end

      it 'should render users to json format' do
        expect(page.body).to include(admin.email)

        expect(page.response_headers['Content-Type']).to eq 'application/json; charset=utf-8'
      end
    end

    describe 'GET /manage/posts/export.csv' do
      before(:each) do
        structure.posts.create(title: 'Some title')

        visit export_path(model_name: 'posts', format: :csv)
      end

      it 'should send csv file with posts' do
        headers = page.response_headers

        expect(headers['Content-Type']).to eq 'text/csv'
        expect(headers['Content-Disposition']).to eq 'attachment; filename="posts_2012-01-01_16h00m00.csv"'

        expect(page.status_code).to eq 200
        expect(page.body).not_to be_blank
        expect(page.body).to include(structure.title)
        expect(page.body).to include(structure.slug)
      end
    end

    describe 'GET /manage/structures/export.xlsx' do
      before(:each) do
        visit export_path(model_name: 'structures', format: :xlsx)
      end

      it 'should send excel file with structures' do
        headers = page.response_headers

        expect(headers['Content-Type']).to eq 'application/vnd.ms-excel'
        expect(headers['Content-Disposition']).to eq 'attachment; filename="structures_2012-01-01_16h00m00.xls"'
      end
    end

    describe 'GET /manage/structures/export.xml' do
      before(:each) do
        visit export_path(model_name: 'structures', format: :xml)
      end

      it 'should render structures to xml format' do
        expect(page.body).to include(root.title)

        expect(page.response_headers['Content-Type']).to eq 'application/xml; charset=utf-8'
      end
    end
  end

  describe 'anonymous user' do
    it 'should redirect to login page' do
      visit export_path(model_name: 'users', format: :xlsx)
      should have_content('You need to sign in or sign up before continuing.')
    end
  end
end

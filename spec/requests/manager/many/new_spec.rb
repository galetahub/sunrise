# frozen_string_literal: true

require 'spec_helper'

describe 'Sunrise Manager New many' do
  subject { page }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:root) { FactoryBot.create(:structure_main) }
  let(:structure) { FactoryBot.create(:structure_page, parent: root) }

  context 'admin' do
    before(:each) { login_as admin }

    describe 'GET /manage/posts/new' do
      before(:each) do
        visit new_path(model_name: 'posts', parent_id: structure.id, parent_type: structure.class.name)
      end

      it 'should show page title' do
        should have_content(I18n.t('manage.add'))
      end

      it 'should generate field to edit' do
        SunrisePost.config.form.fields.each do |f|
          if ['content'].include?(f.name)
            should have_selector "textarea[@name='post[#{f.name}]']"
          else
            should have_selector "input[@name='post[#{f.name}]']"
          end
        end
      end
    end
  end
end

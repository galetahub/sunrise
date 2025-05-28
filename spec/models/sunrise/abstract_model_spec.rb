# frozen_string_literal: true

require 'spec_helper'

describe Sunrise::AbstractModel do
  describe 'SunriseStructure' do
    it 'should return resource_name' do
      expect(SunriseStructure.resource_name).to eq 'Structure'
    end

    it 'should load structure model' do
      expect(SunriseStructure.model).to eq Structure
    end

    it 'should not be abstract_class?' do
      expect(SunriseStructure).not_to be_abstract_class
    end

    context 'instance' do
      before(:each) do
        @params = { structure: { title: 'Some title', slug: 'Some slug' } }
        @abstract_model = Sunrise::Utils.get_model('structures', @params)
      end

      it 'should return valid attributes' do
        expect(@abstract_model.current_list).to eq :tree
        expect(@abstract_model.plural).to eq 'structures'
        expect(@abstract_model.model_name).to eq Structure.model_name
      end

      it 'should return record attrs' do
        expect(@abstract_model.param_key).to eq 'structure'
      end

      it 'should not load parent record' do
        @abstract_model.parent_record.should be_nil
      end

      it 'should get current list settings' do
        @abstract_model.list.should_not be_nil
      end

      it 'should build new record' do
        structure = @abstract_model.build_record
        structure.should be_new_record
      end

      it 'should update current list view' do
        model = Sunrise::Utils.get_model('structures', view: 'thumbs')
        expect(model.current_list).to eq :thumbs
      end

      it 'should destroy all items' do
        @structure = FactoryBot.create(:structure_page)

        lambda {
          @abstract_model.destroy_all(ids: [@structure.id])
        }.should change { Structure.count }.by(-1)
      end
    end
  end

  describe 'SunrisePage' do
    it 'should not have config for list' do
      expect(SunrisePage.config.index).to eq false
    end

    it 'should load structure model' do
      expect(SunriseStructure.model).to eq Structure
    end

    context 'instance' do
      before(:each) do
        @params = { structure: { main: 'Some main content', sidebar: 'Some sidebar content' } }
        @abstract_model = Sunrise::Utils.get_model('pages', @params)
      end

      it 'should not render list config' do
        expect(@abstract_model.without_index?).to eq true
        expect(@abstract_model.list).to eq false
      end
    end
  end

  describe 'SunriseUser' do
    it 'should return empty list on not defined fields' do
      SunrisePage.config.sections[:list_table].should be_nil
    end
  end
end

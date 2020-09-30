# frozen_string_literal: true

require 'spec_helper'

describe Sunrise::AbstractModel do
  describe 'SunriseStructure' do
    it 'should return resource_name' do
      SunriseStructure.resource_name.should == 'Structure'
    end

    it 'should load structure model' do
      SunriseStructure.model.should == Structure
    end

    it 'should not be abstract_class?' do
      SunriseStructure.should_not be_abstract_class
    end

    context 'instance' do
      before(:each) do
        @params = { structure: { title: 'Some title', slug: 'Some slug' } }
        @abstract_model = Sunrise::Utils.get_model('structures', @params)
      end

      it 'should return valid attributes' do
        @abstract_model.current_list.should == :tree
        @abstract_model.plural.should == 'structures'
        @abstract_model.model_name.should == Structure.model_name
      end

      it 'should return record attrs' do
        @abstract_model.param_key.should == 'structure'
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
        model.current_list.should == :thumbs
      end

      it 'should destroy all items' do
        @structure = FactoryGirl.create(:structure_page)

        lambda {
          @abstract_model.destroy_all(ids: [@structure.id])
        }.should change { Structure.count }.by(-1)
      end
    end
  end

  describe 'SunrisePage' do
    it 'should not have config for list' do
      SunrisePage.config.index.should == false
    end

    it 'should load structure model' do
      SunriseStructure.model.should == Structure
    end

    context 'instance' do
      before(:each) do
        @params = { structure: { main: 'Some main content', sidebar: 'Some sidebar content' } }
        @abstract_model = Sunrise::Utils.get_model('pages', @params)
      end

      it 'should not render list config' do
        @abstract_model.without_index?.should == true
        @abstract_model.list.should == false
      end
    end
  end

  describe 'SunriseUser' do
    it 'should return empty list on not defined fields' do
      SunrisePage.config.sections[:list_table].should be_nil
    end
  end
end

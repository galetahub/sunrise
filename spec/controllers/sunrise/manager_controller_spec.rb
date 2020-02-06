# frozen_string_literal: true

require 'spec_helper'

describe Sunrise::ManagerController, type: :controller do
  describe '#current_ability' do
    before(:each) { @ability = controller.send(:current_ability) }

    it 'should have namespace sunrise' do
      @ability.context.should == :sunrise
    end

    it 'should be a guest user' do
      @ability.user.should be_new_record
    end
  end

  describe 'admin' do
    login_admin

    context 'index' do
      before(:all) do
        @root = FactoryGirl.create(:structure_main)
        @page = FactoryGirl.create(:structure_page, parent: @root)
      end

      it 'should respond successfully' do
        get :index, model_name: 'structures'

        assigns(:records).should include(@root)
        assigns(:records).should_not include(@page)

        response.should render_template('index')
      end

      it 'should render 404 page' do
        lambda {
          get :index, model_name: 'wrong'
        }.should raise_error ActionController::RoutingError
      end

      it 'should not destroy root structure' do
        @root.structure_type_id.should == ::StructureType.main.id

        controller.should_not_receive(:destroy)
        delete :destroy, model_name: 'structures', id: @root.id
      end
    end

    context 'posts' do
      before(:all) do
        @post = FactoryGirl.create(:post)
      end

      it 'should respond successfully' do
        get :index, model_name: 'posts'

        assigns(:records).should include(@post)

        response.should render_template('index')
      end
    end
  end
end

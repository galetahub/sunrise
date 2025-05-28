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
        @root = FactoryBot.create(:structure_main)
        @page = FactoryBot.create(:structure_page, parent: @root)
      end

      it 'should respond successfully' do
        get :index, params: { model_name: 'structures' }

        assigns(:records).should include(@root)
        assigns(:records).should_not include(@page)

        response.should render_template('index')
      end

      it 'should render 404 page' do
        expect {
          get :index, params: { model_name: 'wrong' }
        }.to raise_error ActionController::RoutingError
      end

      it 'should not destroy root structure' do
        expect(@root.structure_type_id).to eq ::StructureType.main.id

        expect(controller).not_to receive(:destroy)
        delete :destroy, params: { model_name: 'structures', id: @root.id }
      end
    end

    context 'posts' do
      before(:all) do
        @post = FactoryBot.create(:post)
      end

      it 'should respond successfully' do
        get :index, params: { model_name: 'posts' }

        expect(assigns(:records)).to include(@post)
        expect(response).to render_template('index')
      end
    end
  end
end

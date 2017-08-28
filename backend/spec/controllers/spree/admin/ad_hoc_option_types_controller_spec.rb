require 'spec_helper'


RSpec.describe Spree::Admin::AdHocOptionTypesController, type: :controller do
  stub_authorization!

  let(:option_type) { create(:ad_hoc_option_type) }
  let(:product) { option_type.product }


  describe '#index' do
    subject { get :index, params: { product_id: product.slug } }

    it 'lists all product option types' do
      subject

      expect(assigns(:option_types)).to include(option_type)
      expect(assigns(:product)).to eq(product)
    end
  end

  describe '#new' do
    skip 'older versions wont accept xhr'
    # let!(:option_type_2) { create(:ad_hoc_option_type) }
    # subject { get :new, params: { product_id: product.slug }, xhr: true }

    # it 'sets available option types' do
    #   subject

    #   expect(assigns[:available_option_types]).to include(option_type_2.option_type)
    #   expect(assigns[:available_option_types]).to_not include(option_type.option_type)
    # end
  end

  describe '#add_option_value' do
    let(:option_value) { create(:option_value) }

    context 'on success' do
      subject { get :add_option_value, params: { product_id: product.slug, id: option_type.id, option_value_id: option_value.id } }
      it 'creates an AdHocOptionValue' do
        expect{ subject }.to change(Spree::AdHocOptionValue, :count).by(1)
      end

      it 'adds the option value to the ad hoc option type' do
        expect{ subject }.to change(option_type.option_values, :count).by(1)
      end
    end

    context 'on error' do
      subject { get :add_option_value, params: { product_id: product.slug, id: option_type.id, option_value_id: nil } }

      it 'flashes error' do
        subject

        expect(flash[:error]).to be_present
      end
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: { product_id: product.slug, id: option_type.id } }

    it 'reduces the count of AdHocOptionType by -1' do
      option_type # to make sure it is created before deleting

      expect { subject }.to change(Spree::AdHocOptionType, :count).by(-1)
    end
  end

  describe '#create' do
    let(:product) { create(:product) }
    let(:option_type) { create(:option_type) }
    subject { post :create, params: { product_id: product.slug, option_type_id: option_type.id } }

    it 'increases AdHocOptionType count by 1' do
      expect{ subject }.to change(Spree::AdHocOptionType, :count).by(1)
    end

    it 'adds the AdHocOptionType to the product' do
      expect { subject }.to change(product.ad_hoc_option_types, :count).by(1)
    end
  end
end

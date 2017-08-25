require 'spec_helper'


RSpec.describe Spree::Admin::AdHocOptionValuesController, type: :controller do
  stub_authorization!


  describe '#destroy' do
    let!(:ad_hoc_option_value) { create(:ad_hoc_option_value) }
    let(:ad_hoc_option_type) { ad_hoc_option_value.option_type }
    let(:product) { ad_hoc_option_type.product }
    let(:params) { { product_id: product.slug, ad_hoc_option_type_id: ad_hoc_option_type.id, id: ad_hoc_option_value.id } }

    subject {
      delete :destroy, params: params
    }

    it 'destroys the ad hoc option value' do
      expect { subject }.to change { Spree::AdHocOptionValue.count }.from(1).to(0)
    end
  end
end

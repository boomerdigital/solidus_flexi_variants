require 'spec_helper'


RSpec.describe Spree::Admin::AdHocVariantExclusionsController, type: :controller do
  stub_authorization!

  describe '#create' do
    skip 'TODO'
  end

  describe '#destroy' do
    let!(:ad_hoc_variant_exclusion) { create(:ad_hoc_variant_exclusion) }
    let(:params) { { id: ad_hoc_variant_exclusion.id, product_id: ad_hoc_variant_exclusion.product.id } }

    subject {
      delete :destroy, params: params
    }

    it 'destroys the ad hoc option value' do
      expect { subject }.to change { Spree::AdHocVariantExclusion.count }.from(1).to(0)
    end
  end
end

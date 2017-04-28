require 'spec_helper'


RSpec.describe Spree::Admin::AdHocOptionValuesController, type: :controller do
  stub_authorization!


  describe '#destroy' do
    let!(:ad_hoc_option_value) { create(:ad_hoc_option_value) }
    let(:params) { { id: ad_hoc_option_value.id } }

    subject {
      delete :destroy, params: params
    }

    it 'destroys the ad hoc option value' do
      expect { subject }.to change { Spree::AdHocOptionValue.count }.from(1).to(0)
    end
  end
end

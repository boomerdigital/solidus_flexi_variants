require 'spec_helper'

RSpec.describe Spree::Product do
  let(:product) { create(:product) }
  let(:ad_hoc_option_type) { create(:ad_hoc_option_type) }

  describe '#attach_option_values' do
    subject do
      product.ad_hoc_option_types << ad_hoc_option_type
    end

    it 'creates ad hoc option values from the option types option values' do
      expect {subject}.to change{ad_hoc_option_type.ad_hoc_option_values.length}.from(0).to(1)
    end
  end
end

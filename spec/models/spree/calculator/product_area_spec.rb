require 'spec_helper'

RSpec.describe Spree::Calculator::ProductArea do
  let(:calculator) { described_class.new }
  let(:product_customization) { create(:product_customization, :with_product_area) }

  describe '#compute' do
    it 'returns 0 when no preferences given' do
      expect(calculator.compute(product_customization)).to eq(0.00)
    end

    it 'returns the price_per_letter' do
      calculator.preferred_multiplier = 5
      product_customization.customized_product_options.first.value = 5
      product_customization.customized_product_options.last.value = 5

      expect(calculator.compute(product_customization)).to eq(125)
    end
  end
end

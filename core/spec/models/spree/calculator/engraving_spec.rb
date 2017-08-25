require 'spec_helper'

RSpec.describe Spree::Calculator::Engraving do
  let(:calculator) { described_class.new }
  let(:product_customization) { create(:product_customization, :with_engraving) }

  describe '#compute' do
    it 'returns 0 when no preferences given' do
      expect(calculator.compute(product_customization)).to eq(0.00)
    end

    it 'returns the price_per_letter' do
      calculator.preferred_price_per_letter = 1.00
      product_customization.customized_product_options.first.value = 'letter'

      expect(calculator.compute(product_customization)).to eq(6.00)
    end
  end
end

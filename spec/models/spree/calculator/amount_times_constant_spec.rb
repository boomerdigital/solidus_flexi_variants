require 'spec_helper'

RSpec.describe Spree::Calculator::AmountTimesConstant do
  let(:calculator) { described_class.new }
  let(:product_customization) { create(:product_customization, :with_amount_times_constant) }

  describe '#compute' do
    it 'returns 0 when no preferences given' do
      expect(calculator.compute(product_customization)).to eq(0.00)
    end

    it 'returns the price_per_letter' do
      calculator.preferred_multiplier = 5
      product_customization.customized_product_options.first.value = 5

      expect(calculator.compute(product_customization)).to eq(25)
    end
  end
end

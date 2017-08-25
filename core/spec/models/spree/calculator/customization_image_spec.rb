require 'spec_helper'

RSpec.describe Spree::Calculator::CustomizationImage do
  let(:calculator) { described_class.new }
  let(:product_customization) { create(:product_customization, :with_customization_image) }

  describe '#compute' do
    it 'returns 0 when no image is given' do
      product_customization = create(:product_customization)

      expect(calculator.compute(product_customization)).to eq(0.00)
    end

    it 'returns the preferred_price' do
      calculator.preferred_price = 5.00

      expect(calculator.compute(product_customization)).to eq(5.00)
    end
  end
end

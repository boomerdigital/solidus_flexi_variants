require 'spec_helper'

RSpec.describe Spree::Calculator::NoCharge do
  let(:calculator) { described_class.new }
  let(:product_customization) { create(:product_customization) }
  let(:variant) { product_customization.line_item.variant }

  describe '#compute' do
    it 'adds no charge' do
      expect(calculator.compute(product_customization, variant)).to eq(0)
    end
  end
end

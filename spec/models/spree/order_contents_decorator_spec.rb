require 'spec_helper'

RSpec.describe Spree::OrderContents do
  let(:order) { create(:order) }
  let(:variant) { create(:variant, price: 5.00) }
  subject(:order_contents) { described_class.new(order) }

  describe '#add' do
    context 'with product customization' do
      let(:calc) {
        calc = Spree::Calculator::Engraving.new
        calc.preferred_price_per_letter = 5
        calc
      }
      let(:product_customization) { build(:product_customization, :with_engraving) }

      before do
        product_customization.customized_product_options = [build(:customized_product_option, value: 'A', customizable_product_option: Spree::CustomizableProductOption.find_by(name: 'inscription'))]
        product_customization.product_customization_type.calculator = calc
      end

      it 'updates the order total price to include the price modifier' do
        expect {
          subject.add(variant, 1, {
                        product_customizations: [product_customization],
                        customization_price: 5.00
                      })
        }.to change {
          order.total
        }.from(0.00).to(10.00)
      end

      it 'attaches product customizations to the line item' do
        subject.add(variant, 1, { product_customizations: [product_customization], customization_price: 5.00 })

        expect(order.line_items.first.product_customizations.length).to eq(1)
      end
    end

    context 'with ad hoc option values' do
      let(:ad_hoc_option_value) { create(:ad_hoc_option_value, price_modifier: 5.00, option_value: create(:option_value, name: 'small')) }

      it 'updates the order total price to include the price modifier' do
        expect{ subject.add(variant, 1, { ad_hoc_option_values: [ad_hoc_option_value.id] }) }.to change { order.total }.from(0.00).to(10.00)
      end

      it 'attaches ad hoc option values to the line item' do
        subject.add(variant, 1, { ad_hoc_option_values: [ad_hoc_option_value.id] })

        expect(order.line_items.first.ad_hoc_option_values.length).to eq(1)
      end
    end
  end
end

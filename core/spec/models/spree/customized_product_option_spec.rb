require 'spec_helper'


RSpec.describe Spree::CustomizedProductOption do
  let(:customized_product_option) { build(:customized_product_option, value: value, customization_image: customization_image) }
  describe '#mount_uploader' do
    skip 'TODO'
  end

  describe '#empty?' do
    context 'when value and customization_image are nil' do
      let(:value) { nil }
      let(:customization_image) { nil }

      it 'returns true' do
        expect(customized_product_option.empty?).to be true
      end
    end

    context 'when value and customization_image are present' do
      let(:value) { 'I am the value!' }
      let(:customization_image) { 'will this work?' }

      it 'returns false' do
        expect(customized_product_option.empty?).to be false
      end
    end
  end
end

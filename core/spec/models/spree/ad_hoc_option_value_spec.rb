require 'spec_helper'


RSpec.describe Spree::AdHocOptionValue do
  let(:option_value) { build(:option_value, name: 'large', presentation: 'L') }
  let(:ad_hoc_option_value) { build(:ad_hoc_option_value, option_value: option_value) }


  describe '#name' do
    it 'delegates to option value name' do
      expect(ad_hoc_option_value.name).to eq('large')
    end
  end

  describe '#presentation' do
    it 'delegates to option value presentation' do
      expect(ad_hoc_option_value.presentation).to eq('L')
    end
  end

  describe '#cost_price' do
    skip 'Figure out where this is used'
  end
end

require 'spec_helper'


RSpec.describe Spree::AdHocOptionType do
  let(:option_type) { build(:option_type, name: 'size', presentation: 'Size') }
  let(:ad_hoc_option_type) { build(:ad_hoc_option_type, option_type: option_type) }

  describe '#name' do
    it 'returns the name of the option type' do
      expect(ad_hoc_option_type.name).to eq('size')
    end
  end

  describe '#presentation' do
    it 'returns the presentation of the option type' do
      expect(ad_hoc_option_type.presentation).to eq('Size')
    end
  end

  describe '#has_price_modifier?' do
    skip 'come back to when we find out where or if this is used'
  end
end

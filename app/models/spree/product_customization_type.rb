module Spree
  class ProductCustomizationType < ActiveRecord::Base
    include Spree::CalculatedAdjustments

    has_many :product_customization_types_products, class_name: '::Spree::ProductCustomizationTypesProduct'
    has_many :products, through: :product_customization_types_products

    has_many :customizable_product_options, dependent: :destroy

    accepts_nested_attributes_for :customizable_product_options, allow_destroy: true

    validates :name, :presentation, presence: true
  end
end

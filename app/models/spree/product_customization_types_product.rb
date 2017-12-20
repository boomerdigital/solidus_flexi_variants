module Spree
  class ProductCustomizationTypesProduct < ActiveRecord::Base
  	# associates a product customization type to a product
  	belongs_to :product
  	belongs_to :product_customization_type
  end
end
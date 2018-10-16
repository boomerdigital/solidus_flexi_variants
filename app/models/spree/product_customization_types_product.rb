module Spree
  class ProductCustomizationTypesProduct < ActiveRecord::Base
    belongs_to :product
    belongs_to :product_customization_type
  end
end

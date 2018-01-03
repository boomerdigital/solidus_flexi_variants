require_dependency 'spree/calculator'

module Spree
  class Calculator::Engraving < Calculator
    preference :price_per_letter, :decimal

    def self.description
      "Engraving Calculator"
    end

    def self.register
      super
      ProductCustomizationType.register_calculator(self)
    end

    def create_options
      # This calculator knows that it needs one CustomizableOption named inscription
      [
       CustomizableProductOption.create(name: "inscription", presentation: "Inscription", data_type: "string")
      ]
    end

    def compute(product_customization, variant=nil)
      opt = product_customization.customized_product_options.detect {|cpo| cpo.customizable_product_option.name == "inscription" } rescue ''
      # The rescue will make the next line raise an error, is that what we want?
      opt.value.length * (preferred_price_per_letter || 0)
    end
  end
end

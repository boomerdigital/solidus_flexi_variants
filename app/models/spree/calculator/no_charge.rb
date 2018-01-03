require_dependency 'spree/calculator'

module Spree
  class Calculator::NoCharge < Calculator
    def self.description
      "This customization has no charge"
    end

    def self.register
      super
      ProductCustomizationType.register_calculator(self)
    end

    def create_options
      # This calculator doesn't come with any customizable options. Create your own through the UI
      [
      ]
    end

    def compute(product_customization, variant=nil)
      return 0
    end
  end
end

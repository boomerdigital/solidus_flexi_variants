module Spree
  module Environment
    module CalculatorsDecorator
      def self.prepended(base)
        base.attr_accessor :product_customization_types
      end

      Spree::Environment::Calculators.prepend(self) unless Spree::Environment::Calculators.ancestors.include?(self)
    end
  end
end

module CalculatorsDecorator
  def self.prespended(base)
    base.attr_accessor :product_customization_types
  end

  ::Spree::Core::Environment::Calculators.prepend(self)
end

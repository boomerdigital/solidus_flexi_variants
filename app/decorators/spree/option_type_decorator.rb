module OptionTypeDecorator
  def self.prepended(base)
    base.has_many :ad_hoc_option_types, dependent: :destroy
  end

  ::Spree::OptionType.prepend(self)
end

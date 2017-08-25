module Spree
  class AdHocOptionType < ActiveRecord::Base
    belongs_to :option_type
    belongs_to :product
    has_many :ad_hoc_option_values, dependent: :destroy
    alias :option_values :ad_hoc_option_values

    accepts_nested_attributes_for :ad_hoc_option_values, allow_destroy: true

    validates :option_type, :product, presence: true

    default_scope -> { order(:position) }

    # price_modifier_type
    # is_required
    # TODO What is this all about?
    def has_price_modifier?
      !(price_modifier_type.nil? || price_modifier_type.downcase=~/none/)
    end

    def name
      option_type.name
    end

    def presentation
      option_type.presentation
    end
  end
end

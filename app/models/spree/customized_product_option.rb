module Spree
  # in populate, params[:customization] contains all the fields supplied by
  # the customization_type_view. Those values are saved in this class
  class CustomizedProductOption < ActiveRecord::Base
    belongs_to :product_customization
    belongs_to :customizable_product_option

    mount_uploader :customization_image, CustomizationImageUploader

    def empty?
      value.blank? && !customization_image?
    end

    def display_text
      if customization_image?
        "#{customizable_product_option.presentation} = #{File.basename customization_image.url}"
      else
        "#{customizable_product_option.presentation} = #{value}"
      end
    end
  end
end

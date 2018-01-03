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

    # alternative set method
    def set_value_for_type=(a)
      case self.customizable_product_option.data_type
      when "file"
        self.customization_image = a
      when "multi-select"
        self.json_value = a
      when "single-select"
        self.json_value = a
      when "integer"
        self.integer_value = a
      when "boolean"
        self.boolean_value = a
      when "float"
        self.float_value = a
      else
        self.value = a
      end
    end

    # alternative get method
    def get_value_for_type
      case self.customizable_product_option.data_type
      when "file"
        self.customization_image
      when "multi-select"
        self.json_value
      when "single-select"
        self.json_value
      when "integer"
        self.integer_value
      when "boolean"
        self.boolean_value
      when "float"
        self.float_value
      else
        self.value
      end
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

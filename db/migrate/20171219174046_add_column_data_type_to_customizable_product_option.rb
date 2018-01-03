class AddColumnDataTypeToCustomizableProductOption < SolidusSupport::Migration[4.2]
  def change
  	add_column :spree_customizable_product_options, :data_type, :string, default: "string"
  end
end

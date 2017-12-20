class AddColumnDataTypeToCustomizableProductOption < SolidusSupport::Migration[4.2]
  def change
  	add_column :spree_customizable_product_options, :data_type, :string, default: "string"
  	add_column :spree_customized_product_options, :boolean_value, :boolean
  	add_column :spree_customized_product_options, :integer_value, :integer
  	add_column :spree_customized_product_options, :float_value, :float
  	add_column :spree_customized_product_options, :datetime_value, :datetime
  	add_column :spree_customized_product_options, :json_value, :jsonb
  end
end

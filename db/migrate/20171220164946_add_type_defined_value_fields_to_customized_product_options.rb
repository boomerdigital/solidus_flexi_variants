class AddTypeDefinedValueFieldsToCustomizedProductOptions < SolidusSupport::Migration[4.2]
  def change
  	add_column :spree_customizable_product_options, :selectable_options, :jsonb
  end
end

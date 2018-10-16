class AddIdToSpreeProductCustomizationTypesProducts < SolidusSupport::Migration[5.2]
  def change
    add_column :spree_product_customization_types_products, :id, :primary_key
  end
end

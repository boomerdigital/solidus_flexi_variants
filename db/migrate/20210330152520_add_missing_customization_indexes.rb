class AddMissingCustomizationIndexes < SolidusSupport::Migration[5.2]
  def change
    add_index(:spree_product_customizations,
              :line_item_id,
              name: :index_spree_product_customizations_on_line_item_id) unless index_exists?(:spree_product_customizations,
                                                                                              :line_item_id,
                                                                                              name: :index_spree_product_customizations_on_line_item_id)
    add_index(:spree_product_customizations,
              :product_customization_type_id,
              name: :index_spree_product_customizations_on_cust_type_id) unless index_exists?(:spree_product_customizations,
                                                                                              :product_customization_type_id,
                                                                                              name: :index_spree_product_customizations_on_cust_type_id)

    add_index(:spree_product_customization_types_products,
              :product_id,
              name: :index_spree_product_customization_types_products_on_product_id) unless index_exists?(:spree_product_customization_types_products,
                                                                                                          :product_id,
                                                                                                          name: :index_spree_product_customization_types_products_on_product_id)
    add_index(:spree_product_customization_types_products,
              :product_customization_type_id,
              name: :idx_spree_product_customization_types_products_on_cust_type_id) unless index_exists?(:spree_product_customization_types_products,
                                                                                                          :product_customization_type_id,
                                                                                                          name: :idx_spree_product_customization_types_products_on_cust_type_id)
  end
end

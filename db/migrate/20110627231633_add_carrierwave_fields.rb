class AddCarrierwaveFields < SolidusSupport::Migration[4.2]
  def self.up
    add_column :customized_product_options, :customization_image, :string
  end

  def self.down
    remove_column :customized_product_options, :customization_image
  end
end

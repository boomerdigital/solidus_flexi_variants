class RemoveDataValidationString < SolidusSupport::Migration[4.2]
  def self.up
	 remove_column :customizable_product_options, :data_validation
  end

  def self.down
	 add_column :customizable_product_options, :data_validation, :string
  end
end

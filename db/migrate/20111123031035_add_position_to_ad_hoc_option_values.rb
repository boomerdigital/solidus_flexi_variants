class AddPositionToAdHocOptionValues < SolidusSupport::Migration[4.2]
  def self.up
    add_column :ad_hoc_option_values, :position, :integer
  end

  def self.down
    remove_column :ad_hoc_option_values, :position
  end
end

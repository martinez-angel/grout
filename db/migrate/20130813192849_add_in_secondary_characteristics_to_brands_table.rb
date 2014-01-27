class AddInSecondaryCharacteristicsToBrandsTable < ActiveRecord::Migration
  def change
    add_column :vm_brands, :brand_user_name, :string
    add_column :vm_brands, :brand_industry, :string
    add_column :vm_brands, :fan_size_threshold, :string
    remove_column :page_level_metrics, :brand_user_name
    remove_column :page_level_metrics, :brand_industry
    remove_column :page_level_metrics, :fan_size_threshold
  end
end

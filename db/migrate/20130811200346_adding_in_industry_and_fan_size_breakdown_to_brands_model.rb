class AddingInIndustryAndFanSizeBreakdownToBrandsModel < ActiveRecord::Migration
  def up
    add_column :page_level_metrics, :brand_industry, :string
    add_column :page_level_metrics, :fan_size_threshold, :string
  end

  def down
  end
end

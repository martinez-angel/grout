class AddBrandNametoPageLevelMetrics < ActiveRecord::Migration
  def up
    add_column :page_level_metrics, :brand_name, :string
  end

  def down
  end
end

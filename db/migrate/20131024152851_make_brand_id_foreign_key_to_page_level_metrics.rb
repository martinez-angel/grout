class MakeBrandIdForeignKeyToPageLevelMetrics < ActiveRecord::Migration
  def up
   # remove_column :page_level_metrics, :vm_brand_id
   # remove_column :page_level_metrics, :brand_id
   # add_column :page_level_metrics, :brand_id, :integer
  end

  def down
  end
end

class CreatePageLevelMetrics < ActiveRecord::Migration
  def change
    create_table :page_level_metrics do |t|
      t.string :page_size
      t.string :page_pta
      t.integer :vm_brand_id
      t.string :brand_id
      t.datetime :page_level_date

      t.timestamps
    end
  end
end

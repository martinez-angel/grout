class RemoveRatesfromVmPages < ActiveRecord::Migration
  def up
    remove_column :vm_pages, :post_engagement_rate
    remove_column :vm_pages, :post_virality
  end

  def down
  end
end

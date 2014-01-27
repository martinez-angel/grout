class ChangeVmBrandIdToBrandId < ActiveRecord::Migration
  def up
    rename_column :posts, :vm_brand_id, :brand_id
  end

  def down
  end
end

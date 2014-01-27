class RemoveFansFromVmPages < ActiveRecord::Migration
  def up
    remove_column :vm_pages, :fan_size
  end

  def down
  end
end

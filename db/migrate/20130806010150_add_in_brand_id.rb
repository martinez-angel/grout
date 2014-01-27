class AddInBrandId < ActiveRecord::Migration
  def up
    add_column :vm_pages, :vm_brand_id, :integer
  end

  def down
  end
end

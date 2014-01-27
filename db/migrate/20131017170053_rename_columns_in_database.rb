class RenameColumnsInDatabase < ActiveRecord::Migration
  def up
  	rename_table :vm_brands, :brands
  	rename_table :vm_pages, :posts
  end

  def down
  end
end

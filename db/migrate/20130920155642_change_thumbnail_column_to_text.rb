class ChangeThumbnailColumnToText < ActiveRecord::Migration
  def up
    change_column :vm_pages, :post_thumbnail, :text
  end

  def down
  end
end

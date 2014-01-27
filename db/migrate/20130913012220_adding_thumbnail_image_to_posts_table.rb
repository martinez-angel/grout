class AddingThumbnailImageToPostsTable < ActiveRecord::Migration
  def up
    add_column :vm_pages, :post_thumbnail, :string
  end

  def down
  end
end

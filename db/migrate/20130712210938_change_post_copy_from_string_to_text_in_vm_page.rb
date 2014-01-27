class ChangePostCopyFromStringToTextInVmPage < ActiveRecord::Migration
  def self.up
    change_column :vm_pages, :post_copy, :text, limit: nil
  end

  def down
    change_column :vm_pages, :post_coty, :string
  end
end

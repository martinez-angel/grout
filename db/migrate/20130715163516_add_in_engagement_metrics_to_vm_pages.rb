class AddInEngagementMetricsToVmPages < ActiveRecord::Migration
  def change
    add_column :vm_pages, :post_likes, :string
    add_column :vm_pages, :post_comments, :string
    add_column :vm_pages, :post_shares, :string
  end
end

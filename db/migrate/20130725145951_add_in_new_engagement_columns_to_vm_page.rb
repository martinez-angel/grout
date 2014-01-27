class AddInNewEngagementColumnsToVmPage < ActiveRecord::Migration
  def change
    add_column :vm_pages, :post_likes_stories, :string
    add_column :vm_pages, :post_comments_stories, :string
    add_column :vm_pages, :post_shares_stories, :string
    add_column :vm_pages, :post_likes_pta, :string
    add_column :vm_pages, :post_comments_pta, :string
    add_column :vm_pages, :post_shares_pta, :string
    add_column :vm_pages, :fan_size, :string
    add_column :vm_pages, :post_consumptions_total, :string
    add_column :vm_pages, :post_pta, :string
    remove_column :vm_pages, :post_likes
    remove_column :vm_pages, :post_comments
    remove_column :vm_pages, :post_shares
  
  end


end

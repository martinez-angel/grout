class AddNonFanImpressionsAndViralReachToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :total_impressions_from_fans, :string
    add_column :posts, :total_paid_impressions_from_fans, :string
    add_column :posts, :post_viral_reach, :string
  end
end

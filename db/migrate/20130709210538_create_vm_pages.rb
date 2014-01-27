class CreateVmPages < ActiveRecord::Migration
  def change
    create_table :vm_pages, {:id => true, :force => true} do  |t|
      t.string :brand_name
      t.string :post_id
      t.string :facebook_link
      t.string :post_copy
      t.string :post_type
      t.datetime :post_date
      t.string :post_total_reach
      t.string :post_organic_reach
      t.string :post_paid_reach
      t.string :post_total_impressions
      t.string :post_organic_impressions
      t.string :post_paid_impressions
      t.string :post_lifetime_engaged_users
      t.string :post_lifetime_talking_about_this
      t.string :post_lifetime_negative_feedback_from_users
      t.decimal :post_engagement_rate, :precision => 6, :scale => 4
      t.decimal :post_virality, :precision => 6, :scale => 4

      t.timestamps
    end
  end
end

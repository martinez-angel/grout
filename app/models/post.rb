class Post < ActiveRecord::Base

  attr_accessible :brand_name, :facebook_link, :post_copy, :post_date, :post_engagement_rate,
                  :post_id, :post_lifetime_engaged_users, :post_lifetime_negative_feedback_from_users,
                  :post_lifetime_talking_about_this, :post_organic_impressions, :post_organic_reach,
                  :post_paid_impressions, :post_paid_reach, :post_total_impressions, :post_total_reach,
                  :post_consumptions_unique, :post_type, :post_virality, :post_likes_pta, :post_comments_pta, :post_shares_pta,
                  :post_likes_stories, :post_comments_stories, :post_shares_stories, :post_pta, :post_consumptions_total,
                  :brand_id, :post_thumbnail, :post_viral_reach, :post_viral_impressions, :total_impressions_from_fans,
                  :total_paid_impressions_from_fans, :post_viral_reach, :tags, :primary_tags, :secondary_tags
  before_save validates :post_id, uniqueness: true
  belongs_to :brand
  scope      :last_3_months, where(:post_date => 3.month.ago..Time.now)

end

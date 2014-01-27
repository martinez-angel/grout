class PageLevelMetrics < ActiveRecord::Base

  attr_accessible :page_pta, :page_size, :twenty_eight_day_reach_of_page_posts_organic, :twenty_eight_day_reach_of_page_posts_viral,
                  :twenty_eight_day_total_impressions_of_page_posts, :page_level_date, :brand_id, :brand_name
  before_save validates :page_level_date, presence: true
  belongs_to :brand

end


class AddTwentyEightDayReachNumbersForPageLevelMetrics < ActiveRecord::Migration
  def up
    add_column :page_level_metrics, :twenty_eight_day_reach_of_page_posts_organic, :string
    add_column :page_level_metrics, :twenty_eight_day_reach_of_page_posts_viral, :string
    add_column :page_level_metrics, :twenty_eight_day_total_impressions_of_page_posts, :string
  end

  def down
  end
end

class AddInBrandUserNameToPageLevelMetrics < ActiveRecord::Migration
  def change
    add_column :page_level_metrics, :brand_user_name, :string
  end
end

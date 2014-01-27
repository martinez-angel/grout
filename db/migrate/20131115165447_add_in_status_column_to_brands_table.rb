class AddInStatusColumnToBrandsTable < ActiveRecord::Migration
  def change
    add_column :brands, :brand_status, :boolean, default: true
  end
end

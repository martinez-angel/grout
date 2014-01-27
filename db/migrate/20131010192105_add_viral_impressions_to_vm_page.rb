class AddViralImpressionsToVmPage < ActiveRecord::Migration
  def change
  	add_column :vm_pages, :post_viral_impressions, :string
  end
end

class AddInPostConsumptionsToVmPage < ActiveRecord::Migration
  def change
    add_column :vm_pages, :post_consumptions_unique, :string
  end
end

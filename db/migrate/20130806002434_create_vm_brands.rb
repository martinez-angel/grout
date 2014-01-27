class CreateVmBrands < ActiveRecord::Migration
  def change
    create_table :vm_brands do |t|
      t.string :brand_name

      t.timestamps
    end
  end
end

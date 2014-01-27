class ChangeColumnTypeForTaggingUsingNewActiveRecordChange < ActiveRecord::Migration
  def up
    remove_column :posts, :primary_tags
    remove_column :posts, :secondary_tags
    add_column    :posts, :primary_tags, :string_array
    add_column    :posts, :secondary_tags, :string_array
  end

  def down
  end
end

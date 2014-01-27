class RemoveCurrentTagsAddInNewTaggingStructure < ActiveRecord::Migration
  def up
    remove_column :posts, :tags
    add_column    :posts, :primary_tags, :string, array:true, default: []
    add_column    :posts, :secondary_tags, :string, array:true, default: []
  end

  def down
  end
end

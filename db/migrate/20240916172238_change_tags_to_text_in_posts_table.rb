class ChangeTagsToTextInPostsTable < ActiveRecord::Migration[7.2]
  def change
    change_column :posts, :tags, :text
  end
end

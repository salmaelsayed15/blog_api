class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.text :tags # Change this from string to text to store serialized data

      t.timestamps
    end
  end
end

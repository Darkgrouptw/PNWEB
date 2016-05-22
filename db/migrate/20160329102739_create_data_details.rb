class CreateDataDetails < ActiveRecord::Migration
  def change
    create_table :data_details do |t|
      t.boolean :is_support
      t.text :content
      t.string :link
      t.integer :count
      t.integer :count_like
      t.integer :count_dislike
      t.integer :post_id
      t.integer :people_id
      t.integer :issue_id
      t.string :comment_id

      t.timestamps null: false
    end
  end
end

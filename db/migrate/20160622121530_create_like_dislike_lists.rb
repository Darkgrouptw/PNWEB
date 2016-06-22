class CreateLikeDislikeLists < ActiveRecord::Migration
  def change
    create_table :like_dislike_lists do |t|
      t.integer :detail_id
      t.boolean :is_like
      t.integer :post_id

      t.timestamps null: false
    end
  end
end

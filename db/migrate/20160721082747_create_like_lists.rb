class CreateLikeLists < ActiveRecord::Migration
  def change
    create_table :like_lists do |t|
      t.integer :detail_id
      t.integer :post_id

      t.timestamps null: false
    end
  end
end

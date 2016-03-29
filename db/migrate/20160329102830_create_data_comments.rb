class CreateDataComments < ActiveRecord::Migration
  def change
    create_table :data_comments do |t|
      t.text :content
      t.integer :post_id

      t.timestamps null: false
    end
  end
end

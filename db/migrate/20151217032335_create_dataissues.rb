class CreateDataissues < ActiveRecord::Migration
  def change
    create_table :dataissues do |t|
      t.string :title
      t.text :post
      t.boolean :is_candidate
      t.integer :trunk_id
      t.integer :agree
      t.integer :disagree
      t.integer :popularity

      t.timestamps null: false
    end
  end
end

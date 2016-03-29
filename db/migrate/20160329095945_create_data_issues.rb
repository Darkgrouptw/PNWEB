class CreateDataIssues < ActiveRecord::Migration
  def change
    create_table :data_issues do |t|
      t.string :title
      t.text :post
      t.boolean :is_candidate
      t.integer :trunk_id
      t.integer :popularity
      t.string :datadetail_id

      t.timestamps null: false
    end
  end
end

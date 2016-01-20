class CreateDataIssues < ActiveRecord::Migration
  def change
    create_table :data_issues do |t|
      t.text :content
      t.integer :count
      t.integer :parent_id
      t.string :sub_id
      t.integer :agree
      t.integer :disagree

      t.timestamps null: false
    end
  end
end

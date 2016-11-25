class CreateTreeLinks < ActiveRecord::Migration
  def change
    create_table :tree_links do |t|
      t.integer :issue_id
      t.integer :treeinfo_id
      t.integer :children_id
      t.text :other

      t.timestamps null: false
    end
  end
end

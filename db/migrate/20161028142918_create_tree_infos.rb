class CreateTreeInfos < ActiveRecord::Migration
  def change
    create_table :tree_infos do |t|
      t.text :info
      t.integer :issue_id
      t.integer :people_id
      t.text :like_list_id

      t.timestamps null: false
    end
  end
end

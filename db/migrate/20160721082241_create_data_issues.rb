class CreateDataIssues < ActiveRecord::Migration
  def change
    create_table :data_issues do |t|
      t.string :title
      t.text :post
      t.boolean :is_candidate
      t.string :datadetail_id
      t.string :thumb_up
      t.string :tag

      t.timestamps null: false
    end
  end
end

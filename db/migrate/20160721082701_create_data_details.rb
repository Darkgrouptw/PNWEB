class CreateDataDetails < ActiveRecord::Migration
  def change
    create_table :data_details do |t|
      t.boolean :is_support
      t.text :content
      t.string :link
      t.string :backup_id
      t.text :backup_type
      t.integer :count
      t.text :like_list_id
      t.integer :post_id
      t.integer :people_id
      t.string :people_name
      t.integer :issue_id
      t.string :comment_id
      t.string :news_media
      t.string :report_at
      t.string :title_at_that_time
      t.string :title_at_that_time
      t.boolean :is_direct
      t.boolean :is_report

      t.timestamps null: false
    end
  end
end

class CreateNotifyLists < ActiveRecord::Migration
  def change
    create_table :notify_lists do |t|
      t.integer :user_id
      t.integer :issue_id
      t.time :last_read
      t.time :newest_detail

      t.timestamps null: false
    end
  end
end

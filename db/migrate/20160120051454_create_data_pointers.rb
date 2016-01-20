class CreateDataPointers < ActiveRecord::Migration
  def change
    create_table :data_pointers do |t|
      t.integer :issue_id
      t.string :person_id
      t.string :content_id

      t.timestamps null: false
    end
  end
end

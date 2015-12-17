class CreateDataitems < ActiveRecord::Migration
  def change
    create_table :dataitems do |t|
      t.string :title
      t.string :people
      t.string :job
      t.boolean :is_support
      t.text :content
      t.string :contenttime
      t.string :link
      t.integer :count

      t.timestamps null: false
    end
  end
end

class CreateDataitems < ActiveRecord::Migration
  def change
    create_table :dataitems do |t|
      t.string :title
      t.string :people
      t.boolean :is_support
      t.text :content
      t.integer :count
      t.string :link
	  t.string :job

      t.timestamps null: false
    end
  end
end

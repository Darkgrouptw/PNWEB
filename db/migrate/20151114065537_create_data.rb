class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.string :title
      t.string :people
      t.boolean :is_support
      t.text :content
      t.integer :count

      t.timestamps null: false
    end
  end
end

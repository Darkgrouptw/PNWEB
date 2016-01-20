class CreateDataContents < ActiveRecord::Migration
  def change
    create_table :data_contents do |t|
      t.boolean :is_support
      t.text :text
      t.string :link

      t.timestamps null: false
    end
  end
end

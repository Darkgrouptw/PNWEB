class CreateDataMedia < ActiveRecord::Migration
  def change
    create_table :data_media do |t|
      t.string :name
      t.text :valid_name
      t.string :description
      t.text :datadetail_id

      t.timestamps null: false
    end
  end
end

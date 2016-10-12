class CreateDataPeople < ActiveRecord::Migration
  def change
    create_table :data_people do |t|
      t.string :name
      t.text :valid_name
      t.string :pic_link
      t.string :description
      t.text :datadetail_id

      t.timestamps null: false
    end
  end
end

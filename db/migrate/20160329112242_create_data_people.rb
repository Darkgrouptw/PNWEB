class CreateDataPeople < ActiveRecord::Migration
  def change
    create_table :data_people do |t|
      t.string :name
      t.string :pic_link
      t.string :description

      t.timestamps null: false
    end
  end
end

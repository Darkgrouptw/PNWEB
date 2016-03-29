class CreateDataPesons < ActiveRecord::Migration
  def change
    create_table :data_pesons do |t|
      t.string :name
      t.string :pic_link_string
      t.string :description

      t.timestamps null: false
    end
  end
end

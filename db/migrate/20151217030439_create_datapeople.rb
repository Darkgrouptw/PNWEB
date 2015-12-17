class CreateDatapeople < ActiveRecord::Migration
  def change
    create_table :datapeople do |t|
      t.string :name
      t.string :job
      t.string :pic_link

      t.timestamps null: false
    end
  end
end

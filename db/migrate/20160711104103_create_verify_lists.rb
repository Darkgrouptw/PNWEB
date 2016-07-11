class CreateVerifyLists < ActiveRecord::Migration
  def change
    create_table :verify_lists do |t|
      t.string :email
      t.string :uuid

      t.timestamps null: false
    end
  end
end

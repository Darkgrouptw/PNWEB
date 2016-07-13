class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :token
      t.string :ip
      t.string :nickname
      t.integer :level
      t.integer :sex
      t.string :birth
      t.string :liveplace
      t.datetime :last_login_in
      t.string :own

      t.timestamps null: false
    end
  end
end

class AddPropertyToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :name, :string
    add_column :users, :high_power, :boolean
    add_column :users, :own, :string
  end
end

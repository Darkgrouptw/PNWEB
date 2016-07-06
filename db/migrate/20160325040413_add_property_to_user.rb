class AddPropertyToUser < ActiveRecord::Migration
  def change
    add_column :users, :level, :integer
    add_column :users, :nickname, :string
    add_column :users, :own, :string
  end
end

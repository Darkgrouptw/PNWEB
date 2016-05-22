class AddBackupIdToDataDetails < ActiveRecord::Migration
  def change
    add_column :data_details, :backup_id, :integer
  end
end

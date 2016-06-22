class CreateReportDetails < ActiveRecord::Migration
  def change
    create_table :report_details do |t|
      t.integer :detail_id
      t.boolean :is_check

      t.timestamps null: false
    end
  end
end

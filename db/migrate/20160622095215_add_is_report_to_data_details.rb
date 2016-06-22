class AddIsReportToDataDetails < ActiveRecord::Migration
  def change
    add_column :data_details, :is_report, :boolean
  end
end

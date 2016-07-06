class AddPeopleIdToReportDetail < ActiveRecord::Migration
  def change
    add_column :report_details, :people_id, :integer
  end
end

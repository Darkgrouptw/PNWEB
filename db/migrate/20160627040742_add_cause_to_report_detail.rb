class AddCauseToReportDetail < ActiveRecord::Migration
  def change
    add_column :report_details, :cause, :string
  end
end

class AddTagToDataIssue < ActiveRecord::Migration
  def change
    add_column :data_issues, :tag, :string
  end
end

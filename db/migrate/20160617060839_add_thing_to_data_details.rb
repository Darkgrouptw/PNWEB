class AddThingToDataDetails < ActiveRecord::Migration
  def change
    add_column :data_details, :news_media, :string
    add_column :data_details, :reported_at, :string
    add_column :data_details, :title_at_that_time, :string
    add_column :data_details, :is_direct, :boolean
  end
end

class AddPicLinkToDataPointer < ActiveRecord::Migration
  def change
    add_column :data_pointers, :pic_link, :string
  end
end

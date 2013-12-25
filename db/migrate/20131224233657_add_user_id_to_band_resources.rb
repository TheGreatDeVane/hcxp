class AddUserIdToBandResources < ActiveRecord::Migration
  def change
    add_column :band_resources, :user_id, :integer
  end
end

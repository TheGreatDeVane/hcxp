class AddCountryNameAndTypeToUserLocations < ActiveRecord::Migration
  def change
    add_column :user_locations, :country_name, :string
    add_column :user_locations, :location_type, :string
  end
end

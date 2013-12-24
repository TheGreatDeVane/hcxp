class RemoveGeoColumnsFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :address
    remove_column :events, :street
    remove_column :events, :city
    remove_column :events, :country_name
  end
end

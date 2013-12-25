class RenameTypeToResourceTypeForBandResources < ActiveRecord::Migration
  def change
    rename_column :band_resources, :type, :resource_type
  end
end

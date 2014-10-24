class AddPositionToEventBands < ActiveRecord::Migration
  def change
    add_column :event_bands, :position, :integer
  end
end

class AddDescriptionToEventBands < ActiveRecord::Migration
  def change
    add_column :event_bands, :description, :text
  end
end

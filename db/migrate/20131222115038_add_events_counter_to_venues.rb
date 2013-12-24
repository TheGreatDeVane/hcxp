class AddEventsCounterToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :events_count, :integer
  end
end

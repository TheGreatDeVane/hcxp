class AddEventsCountToBands < ActiveRecord::Migration
  def change
    add_column :bands, :events_count, :integer, default: 0

    Band.reset_column_information
    Band.all.each do |p|
      p.update_attribute :events_count, p.event_bands.length
    end
  end
end

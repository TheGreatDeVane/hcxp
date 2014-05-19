class AddMediumPosterSizeToEventsUploader < ActiveRecord::Migration
  def change
    Event.reset_column_information
    Event.all.each do |e|
      puts "Updating Event #{e.id}"
      e.update_attribute :remote_poster_url, e.poster.url
    end
  end
end

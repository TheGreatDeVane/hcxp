attributes :id, :name, :location, :country_code, :images, :events_count

node(:html_url) { |band| band.url }
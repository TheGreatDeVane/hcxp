require 'rubygems'
require 'mechanize'
require 'nokogiri'

namespace :khcpl do

  desc "Fetch bandcamp album embed"
  task bandcamp_fetch: :environment do
    bandcamp = Khcpl::Player::Bandcamp.new 'http://turnstilehcx.bandcamp.com/'
    album_id = bandcamp.album_id
    puts "Album id: #{album_id}"
  end

end

require 'open-uri'
require 'nokogiri'

module SocialServices
  class Lastfm

    def initialize(url)
      # Set variables
      @url      = url
      @name     = nil
      @raw_name = nil
      @api_key  = Khcpl::Application.config.lastfm_api_key

      fetch_url_name
    end

    def raw_name
      return @raw_name
    end

    def result
      fetch_info
      return @result
    end

    private

    def fetch_url_name
      @raw_name = @url.split('/').last
    end

    def fetch_info
      result  = JSON.parse(open("http://ws.audioscrobbler.com/2.0/?method=artist.getInfo&artist=#{@raw_name}&api_key=#{@api_key}&format=json").read)
      result  = result['artist']

      @result = {
        name:   result['name'] || nil,
        mbid:   result['mbid'],
        url:    result['url'],
        images: factor_images(result),
        tags:   factor_tags(result)
      }

      return @result
    end

    def factor_images(original_result)
      images = {}

      # Recreate images array to more friendly form.
      original_result['image'].each { |i| images[i['size'].to_sym] = i['#text'] }
      
      # Add a square image versions
      images[:small_s]  = images[:small].gsub('/34/', '/34s/')
      images[:medium_s] = images[:medium].gsub('/64/', '/64s/')
      images[:large_s]  = images[:large].gsub('/126/', '/126s/')
      
      return images
    end

    def factor_tags(original_result)
      tags = []

      # Recreate tags array to more friendly form.
      original_result['tags']['tag'].each { |t| tags << t['name'] }

      return tags
    end

  end
end
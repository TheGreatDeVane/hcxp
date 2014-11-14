module Hcxp
  class BandcampParser

    Hcxp::LinkParser.register_url /bandcamp\.com/ do |url|
      Hcxp::BandcampParser.new(url).perform
    end

    def initialize(url)
      @url    = url
      @type   = nil
      @title  = nil
      @meta   = nil
      @thumb  = nil
      @client = nil
    end

    def perform
      set_agent()
      fetch_title()
      fetch_thumb()
      determine_type()
      fetch_meta()

      {url: @url, type: @type, title: @title, meta: @meta, thumb: @thumb}
    end

    private

    def set_agent
      @client = Nokogiri::HTML(open(@url), nil, 'utf-8')
    end

    def fetch_title
      og_title = @client.search('meta[property="og:title"]').first
      @title = og_title.attributes['content'].to_s
    end

    def fetch_meta
      return false if @type == 'bandcamp'

      og_video = @client.css('meta[property="og:video"]').first
      embed_link = og_video.attributes['content'].value
      @meta = {
        album_id: embed_link[/album=\d+/][/\d+/]
      }
    end

    def fetch_thumb
      @thumb = Hcxp::ThumbnailScrapper.new(@client).scrap
    end

    def determine_type
      og_video = @client.search('meta[property="og:video"]')
      @type = (og_video.any?) ? 'bandcamp_album' : 'bandcamp'
    end

  end
end
module Hcxp
  class LastfmParser

    Hcxp::LinkParser.register_url /last\.fm/ do |url|
      Hcxp::LastfmParser.new(url).perform
    end

    def initialize(url)
      @url    = url
      @type   = nil
      @title  = nil
      @meta   = nil
      @thumb  = nil
      @client = nil
      @api    = nil
    end

    def perform
      set_agent()
      set_api()
      fetch_title()
      fetch_thumb()
      determine_type()
      fetch_meta()

      {url: @url, type: @type, title: @title, meta: @meta, thumb: @thumb}
    end

    private

    # Returns bands name taken from given url
    #
    def raw_name
      @url.split('/').last.gsub('+', ' ')
    end

    # Sets api variable which contains artist info from last.fm api
    #
    def set_api
      @api = LASTFM.artist.get_info artist: raw_name()
    end

    # Sets nokogiri agent
    #
    def set_agent
      @client = Nokogiri::HTML(open(@url), nil, 'utf-8')
    end

    # Fetches link title from page source
    #
    def fetch_title
      og_title = @client.search('meta[property="og:title"]').first
      @title = og_title.attributes['content'].to_s
    end

    # Fetches additional info about a band (like thumbs or tags)
    #
    def fetch_meta
      @meta = {
        name:   @api['name'] || nil,
        mbid:   @api['mbid'],
        url:    @api['url'],
        images: factor_images(),
        tags:   factor_tags()
      }
    end

    # Fetches a story thumb from given nokogiri instance
    #
    def fetch_thumb
      @thumb = Hcxp::ThumbnailScrapper.new(@client).scrap
    end

    # Sets a story type
    #
    def determine_type
      @type = 'lastfm'
    end

    # Gets images from api response and formats them to app friendly format
    #
    def factor_images
      images = {}

      # Recreate images array to more friendly form.
      @api['image'].each { |i| images[i['size'].to_sym] = i['content'] }

      # Add a square image versions
      images[:small_s]  = images[:small].gsub('/34/', '/34s/')
      images[:medium_s] = images[:medium].gsub('/64/', '/64s/')
      images[:large_s]  = images[:large].gsub('/126/', '/126s/')

      images
    end

    # Gets tags from api response and formats them to app friendly format
    #
    def factor_tags
      tags = []

      # Recreate tags array to more friendly form.
      @api['tags']['tag'].each { |t| tags << t['name'] }

      tags
    end

  end
end
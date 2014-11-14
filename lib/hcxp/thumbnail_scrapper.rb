require 'nokogiri'
require 'open-uri'
require 'uri'
require 'net/http'
require 'fastimage'

module Hcxp

  # ThumbnailScrapper module based on the reddit's one:
  # https://github.com/reddit/reddit/blob/master/r2/r2/lib/media.py#L367
  class ThumbnailScrapper

    def initialize(source = nil)
      @source = source
    end

    def scrap(source = nil)
      @source = source if source.present?

      raise ArgumentError, 'Please provide an URL or page content you want to scrap' if @source.nil?

      find_thumbnail_image()
    end

    private

    def find_thumbnail_image

      if @source.is_a? Nokogiri::HTML::Document
        doc = @source
      elsif is_image?
        @source
      elsif is_html?
        doc = Nokogiri::HTML(open(@source))
      else
        return nil
      end

      # allow the content author to specify the thumbnail:
      # <meta property="og:image" content="http://...">
      og_image = doc.css("meta[property='og:image']")
      return og_image.first.attributes['content'].value if og_image.any?
      log "No og_image"

      # <link rel="image_src" href="http://...">
      thumb_spec = doc.css("link[rel=image_src]")
      return thumb_spec.first.attributes['href'].value if thumb_spec.any?
      log "No thumb_spec"

      # ok, we have no guidance from the author. look for the largest
      # image on the page with a few caveats. (see below)
      max_area = 0
      max_url  = nil

      for image in doc.css('img') do
        image_url = image.attributes['src'].value
        size      = FastImage.size(image_url)

        # skip image on timeout
        next unless size

        # Calculate area
        area = size[0] * size[1]

        # ignore little images
        if area < 5000
          log "Ignoring little #{image_url}"
          next
        end

        # ignore excessively long/wide images
        if size.max / size.min > 1.5
          log "Ignoring dimensions for #{image_url}"
          next
        end

        if area > max_area
          max_area = area
          max_url = image_url
        end
      end

      max_url
    end

    # Returns content type of a link
    def content_type
      url = URI.parse(@source)
      Net::HTTP.start(url.host, url.port) do |http|
        http.head(url.request_uri)['Content-Type']
      end
    end

    def is_image?
      FastImage.type(@source) != nil
    end

    def is_html?
      content_type.start_with? 'text/html'
    end

    def log(msg)
      Rails.logger.debug "-----> #{msg}"
    end
  end
end
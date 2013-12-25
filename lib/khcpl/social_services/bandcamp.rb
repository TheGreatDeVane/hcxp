module SocialServices
  class Bandcamp

    def initialize(url = nil)
      @url        = url
      @embed_code = nil
      @album_id   = fetch_album_id unless @url.nil?
    end

    def album_id
      return @album_id
    end

    def album_id=(album_id)
      @album_id = album_id
    end

    def embed_url(size = 'medium')
      raise SocialServices::UnknownAlbumId if @album_id.nil?

      "http://bandcamp.com/EmbeddedPlayer/album=#{@album_id}/size=#{size}/bgcol=ffffff/linkcol=0687f5/transparent=true/"
    end

    private

    def fetch_album_id
      raise SocialServices::NoUrlGiven if @url.nil?

      agent = Mechanize.new
      page = agent.get(@url)
      
      og_video_element = Nokogiri::HTML(page.body).css('meta[property="og:video"]')
      
      if og_video_element.any?
        embed_link = og_video_element.first.attributes['content'].value
      else
        raise SocialServices::NoEmbedLinkFound
      end

      return embed_link[/album=\d+/][/\d+/]
    end

  end
end
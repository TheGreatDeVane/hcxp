module Khcpl
  module Player
    class NoEmbedLinkFound < ArgumentError; end
    class NoUrlGiven < ArgumentError; end
    class UnknownAlbumId < ArgumentError; end

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
        raise Khcpl::Player::UnknownAlbumId if @album_id.nil?

        "http://bandcamp.com/EmbeddedPlayer/album=#{@album_id}/size=#{size}/bgcol=ffffff/linkcol=0687f5/transparent=true/"
      end

      private

      def fetch_album_id
        raise Khcpl::Player::NoUrlGiven if @url.nil?

        agent = Mechanize.new
        page = agent.get(@url)
        Rails.logger.info "Page loaded: #{@url}"
        
        og_video_element = Nokogiri::HTML(page.body).css('meta[property="og:video"]')
        
        if og_video_element.any?
          embed_link = og_video_element.first.attributes['content'].value
          Rails.logger.info "Profile embed link obtained: #{embed_link}"
        else
          raise Khcpl::Player::NoEmbedLinkFound
        end

        album_id = embed_link[/album=\d+/][/\d+/]
        Rails.logger.info "Album id obtained: #{album_id}"

        return album_id
      end

    end
  end
end
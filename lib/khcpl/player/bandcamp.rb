module Khcpl
  module Player
    class NoEmbedLinkFound < ArgumentError; end
    class NoUrlGiven < ArgumentError; end

    class Bandcamp

      def initialize(url = nil)
        raise Khcpl::Player::NoUrlGiven if url.nil?
        
        @url      = url
        @album_id = fetch_album_id
      end

      def album_id
        return @album_id
      end

      private

      def fetch_album_id
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
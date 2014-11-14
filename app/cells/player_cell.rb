class PlayerCell < Cell::ViewModel

  def show
    @size      = options[:size]      || 'medium'
    @bgcolor   = options[:bgcolor]   || '000000'
    @linkcol   = options[:linkcolor] || '8fa1b3'
    @tracklist = options[:tracklist] || nil
    @artwork   = options[:artwork]   || nil
    @class     = options[:class]     || nil

    return nil unless model.stories.bandcamp_albums.any?

    render
  end

  def iframe_tag
    sizes = {
      large:  373,
      medium: 120,
      small:  42,
    }

    src = "http://bandcamp.com/EmbeddedPlayer/album=#{model.stories.bandcamp_albums.first.meta['album_id']}"
    src << "/size=#{@size}"
    src << "/bgcol=#{@bgcolor}"
    src << "/linkcol=#{@linkcol}"
    src << "/transparent=true"
    src << "/tracklist=#{@tracklist}" unless @tracklist.nil?
    src << "/artwork=#{@artwork}"     unless @artwork.nil?

    content_tag :iframe, nil,
      class:    "bandcamp-player bandcamp-player-#{@size} #{@class}",
      style:    "border: 0; width: 100%; height: #{sizes[@size.to_sym]}px;",
      src:      src,
      seamless: true if model.resources.bandcamp.first
  end

end

module BandsHelper

  def embed_player(band, bgcolor = '000000', linkcol = '428BCA', size = 'medium')
    sizes = {
      medium: '120',
      small:  '42'
    }
    content_tag :iframe, nil, style:    "border: 0; width: 100%; height: #{sizes[size.to_sym]}px;",
                              src:      "http://bandcamp.com/EmbeddedPlayer/album=#{band.resources.bandcamp.first.data[:album_id]}/size=#{size}/bgcol=#{bgcolor}/linkcol=#{linkcol}/transparent=true/",
                              seamless: true if band.resources.bandcamp.first
  end

  def band_thumb_url(band, size = :large_s)
    band.images[size] if band.images
  end

end

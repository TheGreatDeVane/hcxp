module BandsHelper

  def embed_player(band, bgcolor = 'ffffff', linkcol = '428BCA')
    content_tag :iframe, nil, style:    'border: 0; width: 100%; height: 120px;', 
                              src:      "http://bandcamp.com/EmbeddedPlayer/album=#{band.resources.bandcamp.first.data[:album_id]}/size=medium/bgcol=#{bgcolor}/linkcol=#{linkcol}/transparent=true/", 
                              seamless: true if band.resources.bandcamp.first
  end

end

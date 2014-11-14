class CreateStoryService

  def initialize(band, story)
    @story = story
    @band  = band
  end

  def perform
    clean_url()
    result = save()
    ParseLinkWorker.perform_async(@story.id)

    result
  end

  private

  def save
    @band.save!
  end

  def clean_url
    @story.url = @story.url.split('?').first

    # Change last.fm url to the default domain
    @story.url.gsub! /lastfm\.\w+\//, 'last.fm/' if @story.url =~ /lastfm\.\w+\//
  end

end
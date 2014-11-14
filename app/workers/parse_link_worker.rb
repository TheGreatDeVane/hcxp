class ParseLinkWorker
  include Sidekiq::Worker

  def perform(story_id)
    @story = Story.find(story_id)

    result = Hcxp::LinkParser.process_url @story.url

    @story.update_attributes(
      title: result[:title],
      story_type: result[:type],
      remote_thumbnail_url: result[:thumb],
      meta: result[:meta],
    )
  end

end
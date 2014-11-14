class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_band

  load_and_authorize_resource

  append_view_path 'app/views/bands'
  layout 'single'

  def index
    @stories = @band.stories
  end

  def new
    @story = Story.new
  end

  def create
    @story = @band.stories.build(story_params)
    @story.user = current_user

    begin
      CreateStoryService.new(@band, @story).perform
    rescue ActiveRecord::RecordInvalid => e
      render action: :new
    else
      redirect_to band_stories_path(@band)
    end
  end

  private

  def story_params
    params.require(:story).permit(:url)
  end

  def set_band
    @band = Band.friendly.find(params[:band_id]).decorate
  end
end
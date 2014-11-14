class StoryBand < ActiveRecord::Base
  belongs_to :story
  belongs_to :band
end

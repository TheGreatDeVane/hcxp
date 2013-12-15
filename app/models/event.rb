class Event < ActiveRecord::Base
  acts_as_taggable_on :bands
end
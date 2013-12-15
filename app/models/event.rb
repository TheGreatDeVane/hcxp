class Event < ActiveRecord::Base
  acts_as_ordered_taggable_on :bands

  validates :user_id, presence: true
end
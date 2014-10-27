class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: true

  has_many :saves
  has_many :saved_events, through: :saves, source: :event
  has_many :events
  has_many :services
  has_many :locations, class_name: 'UserLocation'

  def to_s
    username || email
  end

  def recent_venues
    Venue.where(id: events.select(:venue_id)).uniq
  end

  def has_saved(object)
    saves.where(saveable_type: object.class.name, saveable_id: object.id).any?
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    super & %w(username)
  end
end

class Story < ActiveRecord::Base

  # Relations
  belongs_to :user
  has_many :story_bands
  has_many :bands, through: :story_bands

  # Hooks
  before_validation :set_defaults
  # before_validation :clean_url
  # after_initialize :set_proper_lastfm_domain

  # Validations
  validates :url, presence: true, uniqueness: true
  validates :url, format: { with: /http\:\/\/.+/ }
  validates :url, format: {
    with: /(bandcamp\.com\/)|(last\.fm\/)|(facebook\.com\/)/,
    message: 'can currently point only to bandcamp, last.fm or facebook profile'
  }

  # Scopes
  scope :bandcamp_albums, -> { where(story_type: 'bandcamp_album') }
  scope :bandcamp,        -> { where(story_type: 'bandcamp') }
  scope :lastfm,          -> { where(story_type: 'lastfm') }

  # Misc
  mount_uploader :thumbnail, StoryThumbUploader


  private

  def set_defaults
    self.status ||= 'pending'
  end

  def clean_url
    self.url = url.split('?').first
  end

  def set_proper_lastfm_domain
    if url =~ /lastfm\.\w+\//
      self.url.gsub! /lastfm\.\w+\//, 'last.fm/'
    end
  end
end

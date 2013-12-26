class BandResource < ActiveRecord::Base
  belongs_to :band
  belongs_to :user

  cattr_accessor :account

  serialize :data, Hash

  validates :url, presence: true
  validates :resource_type, presence: true
  validates :band_id, presence: true

  # TODO: I'am not able to set user_id on band controller.
  # http://stackoverflow.com/q/20773853/552936
  # validates :user_id, presence: true

  scope :bandcamp, -> { where(resource_type: 'bandcamp') }
  scope :lastfm,   -> { where(resource_type: 'lastfm') }

  before_save :populate_data, if: :url_changed?

  def populate_data
    case self.resource_type
    when 'bandcamp'
      bandcamp  = SocialServices::Bandcamp.new self.url
      self.data = { album_id: bandcamp.album_id }
    when 'lastfm'
      lastfm  = SocialServices::Lastfm.new self.url
      self.data = lastfm.result
    end

  rescue SocialServices::Exceptions::NoEmbedLinkFound
    looger.info "No album id found for #{self.id}"

  rescue => e
    logger.error "Something went wrong (url: #{self.url})"
    logger.info  e.message
    logger.debug e.backtrace
  end
end

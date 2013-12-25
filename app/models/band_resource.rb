class BandResource < ActiveRecord::Base
  belongs_to :band
  belongs_to :user

  serialize :data, Hash

  validates :url, presence: true
  validates :resource_type, presence: true
  validates :user_id, presence: true
  validates :band_id, presence: true

  scope :bandcamp, -> { where(resource_type: 'bandcamp') }

  before_save :populate_data, if: :url_changed?

  def populate_data
    case self.resource_type
    when 'bandcamp'
      bandcamp  = Khcpl::Player::Bandcamp.new self.url
      self.data = { album_id: bandcamp.album_id }
    end

  rescue Khcpl::Player::NoEmbedLinkFound
    looger.info "No album id found for #{self.id}"
  end
end

class Event < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, against: [:title, :beginning_at],
                           associated_against: {
                             bands: [:name],
                             venue: [:name, :address, :city, :country_name, :country_code]
                           },
                           using: { 
                             tsearch: { prefix: true } 
                           }

  has_many :event_bands
  has_many :bands, through: :event_bands
  belongs_to :venue, counter_cache: true

  mount_uploader :poster, PosterUploader

  # Validations
  validates :user_id, presence: true

  # Nested attributes
  accepts_nested_attributes_for :bands, allow_destroy: true, 
                                        reject_if: :all_blank
  accepts_nested_attributes_for :venue, allow_destroy: false, 
                                        reject_if: :all_blank,
                                        limit: 1

  # Scopes
  scope :from_the_future, -> { where('beginning_at >= ?', Date.today) }
  scope :from_the_past,   -> { where('beginning_at < ?', Date.today) }

  # Return title or bands list
  def title_or_bands
    if title.present?
      title
    else
      bands.join(', ')
    end
  end
end
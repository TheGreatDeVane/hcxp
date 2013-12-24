class Event < ActiveRecord::Base
  searchkick autocomplete: [:title]
  
  has_many :event_bands
  has_many :bands, through: :event_bands
  belongs_to :venue, counter_cache: true

  mount_uploader :poster, PosterUploader

  # Validations
  validates :user_id, presence: true

  accepts_nested_attributes_for :bands, allow_destroy: true, 
                                        reject_if: :all_blank
  accepts_nested_attributes_for :venue, allow_destroy: false, 
                                        reject_if: :all_blank,
                                        limit: 1

  def search_data
    {
      title: title,
      description: description,
      bands: bands.map(&:name).join(' '),
      venue: venue
    }
  end
end
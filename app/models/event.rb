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

  has_many   :event_bands
  has_many   :bands, through: :event_bands
  belongs_to :venue, counter_cache: true
  belongs_to :user

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

  after_save :puts_changes

  def to_s
    title_or_bands
  end

  # Return title or bands list
  def title_or_bands
    if title.present?
      title
    else
      bands.join(', ')
    end
  end

  # Does event have any social links set?
  def has_any_social_links?
    self.social_link_fb.present? || self.social_link_lfm.present? || self.social_link_hcpl.present?
  end

  def puts_changes
    puts self.changes
  end

  def self.similar_by(options = {})
    select_query = sprintf(

      "events.*,
      similarity(
        events.title, %{title}
      ) + similarity(
        events.description, %{description}
      ) + similarity(
        array_to_string(array(
        SELECT bands.name
        FROM bands
        INNER JOIN event_bands
        ON bands.id = event_bands.band_id
        WHERE event_bands.event_id = events.id
      ), ' '), %{bands})
      AS similarity",

      title:       ActiveRecord::Base::sanitize(options[:title]) || '',
      description: ActiveRecord::Base::sanitize(options[:description])  || '',
      bands:       ActiveRecord::Base::sanitize(options[:bands]) || ''
    )
    similar = Event.select(select_query).order('similarity DESC')
    similar = similar.where('id != ?', options[:exclude]) if options[:exclude].present?
    similar
  end

  def similar
    Event.similar_by(
      title:       title,
      description: description,
      bands:       bands.map(&:name).join(' '),
      exclude:     id
    )
  end
end
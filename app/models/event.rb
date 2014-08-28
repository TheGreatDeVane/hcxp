class Event < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include PgSearch

  is_impressionable counter_cache: true, unique: [:impressionable_type, :impressionable_id, :session_hash]

  pg_search_scope :search, against: [:title, :beginning_at],
                           associated_against: {
                             bands: [:name],
                             venue: [:name, :address, :city, :country_name, :country_code],
                             user:  [:username]
                           },
                           using: {
                             tsearch: { prefix: true }
                           }

  has_many   :event_bands
  has_many   :bands, through: :event_bands
  belongs_to :venue, counter_cache: true
  belongs_to :user
  has_many   :saves
  has_many   :savegazers, through: :saves, source: :user

  mount_uploader :poster, PosterUploader

  # Validations
  validates :user_id, presence: true
  validates :beginning_at, presence: true
  validates :venue_id, presence: true

  # Nested attributes
  accepts_nested_attributes_for :event_bands, allow_destroy: true,
                                        reject_if: :all_blank
  accepts_nested_attributes_for :bands, allow_destroy: true,
                                        reject_if: :all_blank
  accepts_nested_attributes_for :venue, allow_destroy: false,
                                        reject_if: :all_blank,
                                        limit: 1

  # Scopes
  default_scope              { order(:beginning_at) }
  scope :from_the_future, -> { where('beginning_at >= ?', Date.today.beginning_of_day) }
  scope :from_the_past,   -> { where('beginning_at < ?', Date.today) }
  scope :featured,        -> { where(is_promoted: true) }

  # Callbacks
  after_save    :puts_changes
  after_save    :sync
  after_destroy :sync_destroy

  def to_s
    title_or_bands
  end

  # Return title or bands list
  def title_or_bands
    if title.present?
      title
    else
      bands.map(&:name).join(', ').to_s
    end
  end

  # Does event have any social links set?
  def has_any_social_links?
    self.social_link_fb.present? || self.social_link_lfm.present? || self.social_link_hcpl.present?
  end

  def puts_changes
    # puts self.changes
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

  def has_passed
    beginning_at < Date.today
  end

  def slug
    title_or_bands.downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')
  end

  def path
    slugged_event_path(self, self.slug)
  end

  def sync(what = :all)
    return unless Settings.sync.enabled

    e = Khcpl::Exporters::Fhcpl.new

    if !bindings.nil? && self.bindings['fhcpl']
      e.update(bindings['fhcpl'], self)
    else
      self.update_column(:bindings, "fhcpl => #{e.create(self).to_i}")
    end
  end

  def sync_destroy(what = :all)
    return unless Settings.sync.enabled

    e = Khcpl::Exporters::Fhcpl.new
    e.destroy(bindings['fhcpl'])
  end

  def other_events_in_the_city
    city      = venue.city
    venue_ids = Venue.where(city: city).map(&:id)

    Event.from_the_future
      .where(venue_id: venue_ids)
      .where.not(id: id)
  end

  def views_count
    # impressionist_count
    impressions_count
  end

  def self.from_cities(cities = [])
    self.joins(:venue).where('venues.city IN (?)', cities)
  end
end
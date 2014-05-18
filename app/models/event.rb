class Event < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include PgSearch

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

  mount_uploader :poster, PosterUploader

  # Validations
  validates :user_id, presence: true
  validates :beginning_at, presence: true
  validates :title, no_capslock: true

  # Nested attributes
  accepts_nested_attributes_for :bands, allow_destroy: true,
                                        reject_if: :all_blank
  accepts_nested_attributes_for :venue, allow_destroy: false,
                                        reject_if: :all_blank,
                                        limit: 1

  # Scopes
  default_scope order(:beginning_at)
  scope :from_the_future, -> { where('beginning_at >= ?', Date.today) }
  scope :from_the_past,   -> { where('beginning_at < ?', Date.today) }

  # Callbacks
  after_save :puts_changes

  def to_s
    title_or_bands
  end

  def self.parse_search(query, user_id)
    include_past = false
    only_past    = false
    only_saved   = false

    # Only past events filter
    if query.start_with? '--'
      query     = query.reverse[0...-2].reverse
      only_past = true
      logger.info "-----> Double minus detected, display only past events"

    # Also past events filter
    elsif query.start_with? '-'
      query        = query.reverse[0...-1].reverse
      include_past = true
      logger.info "-----> Minus detected, include events from the past"
    end

    # Saved filter
    if query.include? ':s'
      query      = query.gsub(':s', '')
      only_saved = true
      logger.info "-----> Saved flag detected, show only saved events"
    end

    # Remove useless spaces
    query = query.strip

    if query.empty?
      logger.info "-----> Query is empty, do not use #search"
      events = Event.all
    else
      logger.info "-----> Query is not empty, use #search"
      events = Event.search(query)
    end

    # Apply conditional scopes
    events = events.from_the_past if only_past
    events = events.from_the_future if !only_past && !include_past
    events = events.where(id: User.find(user_id).saved_events.map(&:id)) if only_saved && user_id.present?

    events
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

  def has_passed
    beginning_at < Date.today
  end

  def slug
    title_or_bands.downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')
  end

  def path
    slugged_event_path(self, self.slug)
  end
end
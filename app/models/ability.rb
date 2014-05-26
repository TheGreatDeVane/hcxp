class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # Guests
    can :read, :all

    # Members
    unless user.new_record?
      can [:edit, :update, :new, :create], Event, user_id: user.id
      can [:edit, :update, :new, :create], Band
      can [:edit, :update, :new, :create], Venue
    end

    if user.is_admin
      can [:promote], Event
      can [:destroy], Event
      can [:edit, :update], Event
    end
  end
end

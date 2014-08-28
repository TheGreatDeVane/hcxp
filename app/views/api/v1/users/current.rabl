object @user

extends 'api/v1/users/user'

node(:hosted) { |u| u.events.count }
node(:saved)  { |u| u.saved_events.count }
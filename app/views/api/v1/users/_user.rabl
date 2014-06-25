attributes :id
attributes :username

node(:avatar_url) { |user| avatar_url(user, size: -1) }

node(:profile_path) { |user| search_index_path(q: user.username) }
collection @events, root: false, object_root: false

attributes :id, :title, :title_or_bands, :similarity

node(:bands) { |e| e.bands.map { |b| [b.name] } }
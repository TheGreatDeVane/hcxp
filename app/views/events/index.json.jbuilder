json.array!(@events) do |event|
  json.extract! event, :id, :title, :poster, :user_id, :description, :beginning_at, :beginning_at_time, :ending_at, :ending_at_time, :price, :address
  json.url event_url(event, format: :json)
end

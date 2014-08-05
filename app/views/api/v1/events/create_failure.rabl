object false

child @event => :event do
  object @event

  node(:errors) do |e|
  	{
  	  full_messages: e.errors.full_messages
  	}
  end
end
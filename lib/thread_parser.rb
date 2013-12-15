# Given url is not 
class WrongUrl < Exception; end

class ThreadParser
  attr_accessor :url, :id, :type

  TYPE_THREAD = 'thread'
  TYPE_POST   = 'post'

  def initialize(h)
    h.each {|k,v| send("#{k}=",v)}

    if @id
      @url = generate_url
    elsif @url
      @type = discover_type
      @id   = discover_id
    else
      raise ArgumentError, 'Please provide `url` or `id` param'
    end
  end

  # Determine thread ID based on URL params (t=)
  def discover_id
    params = Rack::Utils.parse_query URI(@url).query
    params['t'].to_i
  end

  private

  def discover_type
    params = Rack::Utils.parse_query URI(@url).query
    
    if params['t'].present?
      TYPE_THREAD
    elsif params['p'].present?
      raise WrongUrl, 'Unsupported thread type (post)'
    else
      raise WrongUrl, 'Unknown thread type'
    end
  end

  def generate_url
    "http://forum.hard-core.pl/viewtopic.php?t=#{@id}"
  end
end
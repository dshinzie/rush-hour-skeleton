require 'json'
require 'useragent'
require 'uri'

module Processor
extend self

  def clean_data(params)
    {identifier: params[:identifier], root_url: params[:rootUrl]}
  end

  def json_parser(params)
    JSON.parse(params)
  end

  def params_cleaner(params)
    user_agent, referredby, url = params_parser(params)
    params = json_parser(params)
    {
       requested_at: params['requestedAt'],
       responded_in: params['respondedIn'],
       referred_by: ReferredBy.find_by(root_url: referredby.host, path: referredby.path),
       request_type: RequestType.find_by(http_verb: params['requestType']),
       event: Event.find_by(event_name: params['eventName']),
       agent: Agent.find_by(browser: user_agent.browser, operating_system: user_agent.platform),
       resolution: Resolution.find_by(height: params['resolutionHeight'], width: params['resolutionWidth']),
       ip: Ip.find_by(address: params['ip']),
       url: Url.find_by(root_url: url.host, path: url.path)
    }
  end


  def does_payload_exist?(params, client)
    user_agent, referredby, url = params_parser(params)

    Payload.find_by(params_cleaner(params))
  end

  def params_parser(params)
    params = json_parser(params)
    user_agent = UserAgent.parse(params)['userAgent']
    referredby = URI.parse(params)['referredBy']
    url = URI.parse(params)['url']

    [user_agent, referredby, url]
  end

  def get_client_stats(identifier)
    Client.find_by(identifier: identifier)
  end

  def get_url_stats(relativepath)
    Url.find_by(path: relativepath)
  end

  def get_client_events(client)
    client.event.distinct.map{|e| e.event_name}
  end

  def get_event_stats(client, eventname)
    dates = client.payload.where(event: Event.find_by(event_name: eventname))

    date_array = dates.map do |d|
      DateTime.parse(d.requested_at)
    end.map { |x| x.hour }.sort
    final_hours = (0..24).to_a - date_array

    date_hash = date_array.reduce(Hash.new(0)) {|result, e| result[e] += 1; result}
    hours_hash = final_hours.reduce({}) { |result, e|  result[e] = 0; result}
    date_hash.merge(hours_hash).sort.to_h
  end

  def controller_info(identifier, relativepath=nil, eventname=nil )
    client = get_client_stats(identifier)
    events = get_client_events(client) if !client.nil?
    url = get_url_stats('/' + relativepath) if !relativepath.nil?
    data = get_event_stats(client, eventname) if !eventname.nil?
    total = data.values.reduce(:+) if !data.nil?
    {
      client: client,
      events: events, 
      url:  url,
      eventname: eventname,
      data: data,
      total: total
    }
  end

end

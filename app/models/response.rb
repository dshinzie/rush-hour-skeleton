module Response
  extend self

  def process_client(client, client_identifier)
    if Client.find_by(identifier: client_identifier)
      [403, "Identifier #{client_identifier} already exists\n"]
    elsif client.save
      [200, "{'identifier':'#{client_identifier}'}\n"]
    else
      [400, "#{client.errors.full_messages.join("\n")}\n"]
    end
  end

  def process_data(params, identifier)
    client = Client.find_by(identifier: identifier)
    if client.nil?
      [403,"Client #{identifier} is not registered\n"]
    elsif params[:payload].nil?
      [403, "Missing parameters\n"]
    elsif Processor.does_payload_exist?(params[:payload], client)
      [403, "Payload already exists\n"]
    else
      data_responder(client, params)
    end
  end

  def data_responder(client, params)
    clean_data = Processor.params_cleaner(params[:payload])
    payload = client.payload.create(clean_data)

    if payload.save
      [200, "OK\n"]
    else
      [400, "#{client.payload.errors.full_messages.join("\n")}\n"]
    end
  end
end

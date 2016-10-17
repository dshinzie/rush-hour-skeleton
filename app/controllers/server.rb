require_relative "../models/response.rb"
require_relative "../models/processor.rb"
require 'pry'

module RushHour
  class Server < Sinatra::Base
    include Response, Processor

    not_found do
      erb :error
    end

    get "/" do
      erb :index
    end

    get "/sources/:identifier" do |identifier|
      @info = Processor.controller_info(identifier)
      if Client.find_by(identifier: identifier).nil?
        @message = "Identifier #{identifier} does not exist!"
        erb :error
      elsif Client.find_by(identifier: identifier).payload.empty?
        @message = "Your identifier #{identifier} does not have any assigned payloads!"
        erb :error
      else
        erb :show
      end
    end

    get "/sources/:IDENTIFIER/urls/:RELATIVEPATH" do |identifier, relativepath|
      @info = Processor.controller_info(identifier, relativepath)

      if Url.find_by(path: "/#{relativepath}").nil?
        @message = "Path #{relativepath} does not exist!"
        erb :error
      else
        erb :show_url
      end
    end

    get "/sources/:IDENTIFIER/events/:EVENTNAME" do |identifier, eventname|
      @info = Processor.controller_info(identifier, nil, eventname)

      if Payload.find_by(event: Event.find_by(event_name: eventname)).nil?
        @message = "Event #{eventname} does not exist!"
        erb :error
      else
        erb :event_name
      end

    end

    post "/sources" do
      data = Processor.clean_data(params)
      status, body = Response.process_client(Client.new(data), params[:identifier])
    end

    post "/sources/:IDENTIFIER/data" do |identifier|
      status, body = Response.process_data(params, identifier)
    end

    get "/redirect" do
      @identifier = params["search-id"]

      if Client.find_by(identifier: @identifier).nil?
        @message = "Identifier #{@identifier} does not exist!"
        erb :error
      else
        redirect "/sources/#{@identifier}"
      end
    end

    get "/sources" do
      @sources = Client.all
      erb :sources
    end

  end
end

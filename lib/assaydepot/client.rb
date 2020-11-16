require "uri"
require "rack"
require "open-uri"
require "json"
require 'net/http'

module AssayDepot
  class Client
    def initialize(options={})
      @model_type = options[:model_type] || "wares"
    end

    def search_url(params={})
      format = params.delete(:format)
      format ||= "json"
      query_string = Rack::Utils.build_nested_query(params)
      ["#{AssayDepot.url}/#{@model_type}.#{format}", query_string].compact.join("?")
    end

    def get_url(id, params={})
      format = params.delete(:format)
      format ||= "json"
      query_string = Rack::Utils.build_nested_query(params)
      ["#{AssayDepot.url}/#{@model_type}/#{id}.#{format}", query_string].compact.join("?")
    end

    def index(params={})
      params["access_token"] = AssayDepot.access_token
      execute_get(search_url(params))
    end

    def search(query, facets, params={})
      params["access_token"] = AssayDepot.access_token
      params["q"] = query
      facets.map do |name,value|
        params["facets[#{name}][]"] = value
      end
      execute_get(search_url(params))
    end

    def get(id, params={})
      params["access_token"] = AssayDepot.access_token
      if params[:format] == "pdf"
        execute_get_raw(get_url(id, params))
      else
        execute_get(get_url(id, params))
      end
    end

    def execute_get(url)
      JSON.parse(execute_get_raw(url))
    end

    def execute_get_raw(url)
      URI.open(url).read
    end

    def execute_post(url, payload)
      headers = {
        "Authorization" => "Bearer #{AssayDepot.access_token}",
        "Content-Type" => "application/json"
      }
      url = URI.parse(url)

      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Post.new(url.request_uri, headers)
      request.body = payload.to_json
      response = http.request(request)

      # response = http.post(url.path, payload.to_json, headers)
      response
    end
  end
end

require "open-uri"
require "json"
require 'net/http'

module AssayDepot
  class Client
    def initialize(options={})
      @model_type = options[:model_type] || "wares"
    end

    def search_url(params={})
      "#{AssayDepot.url}/#{@model_type}.json"
    end

    def get_url(id, params={})
      "#{AssayDepot.url}/#{@model_type}/#{id}.json"
    end

    def index(params={})
      params["access_token"] = AssayDepot.access_token
      execute_get(search_url, params)
    end

    def search(query, facets, params={})
      params["access_token"] = AssayDepot.access_token
      params["q"] = query
      facets.map do |name,value|
        params["facets[#{name}][]"] = value
      end
      execute_get(search_url, params)
    end

    def get(id, params={})
      params["access_token"] = AssayDepot.access_token
      execute_get(get_url(id), params)
    end

    def execute_get(url, params)
      JSON.parse(open("#{url}?#{params.collect { |k,v| "#{k}=#{v.to_s.gsub(" ","+")}"}.join("&")}").read)
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

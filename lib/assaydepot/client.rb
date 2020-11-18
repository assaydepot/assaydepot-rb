require "open-uri"
require "json"
require 'net/http'
require 'rack'

module AssayDepot
  class Client

    def initialize(options={})
      @endpoint = options[:endpoint]
    end

    def request(url, params={}, headers={}, auth={})
      uri = URI( "#{url}" )
      uri.query = Rack::Utils.build_nested_query(params) unless params.keys.length == 0
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme === 'https'
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth auth[:username], auth[:password] unless auth[:username].nil?
      res = http.request(request)
      JSON.parse(res.body)
    end

    def get(params={})
      uri = get_uri( params )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme === 'https'
      request = Net::HTTP::Get.new(uri.request_uri)
      puts "CLIENT.GET [#{uri.host}] [#{uri.port}] [#{uri.request_uri}]" if ENV["DEBUG"] == "true"
      request["Authorization"] = "Bearer #{AssayDepot.access_token}" unless params[:access_token]
      res = http.request(request)
      JSON.parse(res.body)
    end

    def put(body={}, params={})
      uri = get_uri( params )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme === 'https'
      request = Net::HTTP::Put.new(uri.request_uri)
      request["Authorization"] = "Bearer #{AssayDepot.access_token}" unless params[:access_token]
      request["Content-Type"] = "application/json"
      if (body.keys.length > 0)
        request.body = body.to_json
      end
      res = http.request(request)
      JSON.parse(res.body)
    end

    def post(body={}, params={})
      uri = get_uri( params )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme === 'https'
      request = Net::HTTP::Post.new(uri.request_uri)
      request["Authorization"] = "Bearer #{AssayDepot.access_token}" unless params[:access_token]
      request["Accept"] = "application/json"
      request["Content-Type"] = "application/json"
      if (body.keys.length > 0)
        request.body = body.to_json
      end
      res = http.request(request)
      JSON.parse(res.body)
    end

    def delete(params={})
      uri = get_uri( params )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme === 'https'
      request = Net::HTTP::Delete.new(uri.request_uri)
      request["Authorization"] = "Bearer #{AssayDepot.access_token}" unless params[:access_token]
      res = http.request(request)
      JSON.parse(res.body)
    end

    def search(query, facets, params={})
      params["q"] = query if query != ""
      facets&.map do |name,value|
        params["facets[#{name}][]"] = value
      end
      get(params)
    end

    private

    def get_uri( params )
      uri = URI( "#{AssayDepot.url}/#{@endpoint}" )
      uri.query = Rack::Utils.build_nested_query(params) unless params.keys.length == 0
      uri
    end
  end
end

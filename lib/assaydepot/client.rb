require "open-uri"
require "json"

module AssayDepot
  class Client    
    def initialize(options={})
      @search_type = options[:search_type] || "wares"
    end

    def search_url(params={})
      "#{AssayDepot.url}/#{@search_type}.json?#{params.collect { |k,v| "#{k}=#{v.to_s.gsub(" ","+")}"}.join("&")}"
    end

    def get_url(id, params={})
      "#{AssayDepot.url}/#{@search_type}/#{id}.json?#{params.collect { |k,v| "#{k}=#{v.to_s.gsub(" ","+")}"}.join("&")}"
    end

    def search(query, facets, params={})
      params["access_token"] = AssayDepot.access_token
      params["q"] = query
      facets.map do |name,value|
        params["facets[#{name}][]"] = value
      end
      JSON.parse(open(search_url(params)).read)
    end

    def get(id, params={})
      params["access_token"] = AssayDepot.access_token
      JSON.parse(open(get_url(id, params)).read)
    end
  end
end
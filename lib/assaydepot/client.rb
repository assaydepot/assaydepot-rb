require "open-uri"
require "json"

module AssayDepot
  class Client    
    def initialize(options={})
      @search_type = options[:search_type] || "wares"
    end

    def search_url(params={})
      "#{AssayDepot.url}/#{@search_type}.json"
    end

    def get_url(id, params={})
      "#{AssayDepot.url}/#{@search_type}/#{id}.json"
    end

    def search(query, facets, params={})
      params["access_token"] = AssayDepot.access_token
      params["q"] = query
      facets.map do |name,value|
        params["facets[#{name}][]"] = value
      end
      execute(search_url, params)
    end

    def get(id, params={})
      params["access_token"] = AssayDepot.access_token
      execute(get_url(id), params)
    end

    def execute(url, params)
      JSON.parse(open("#{url}?#{params.collect { |k,v| "#{k}=#{v.to_s.gsub(" ","+")}"}.join("&")}").read)
    end
  end
end
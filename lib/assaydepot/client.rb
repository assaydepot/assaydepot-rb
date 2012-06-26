require "open-uri"
require "json"

module AssayDepot
  class Client    
    def initialize(options={})
      @search_type = options[:search_type] || "wares"
      # @url = options[:url] || "http://www.assaydepot.com/api"
      # @auth_token = options[:auth_token]
    end

    def search(query, facets, page=1)
      params = {}
      params["auth_token"] = AssayDepot.auth_token
      params["q"] = query
      params["page"] = page.to_s
      facets.map do |name,value|
        params["facets[#{name}][]"] = value
      end
      # EXAMPLE: http://localhost:3000/api/wares.json?facets[available_provider_names][]=Assay+Depot
      JSON.parse(open("#{AssayDepot.url}/#{@search_type}.json?#{params.collect { |k,v| "#{k}=#{v.gsub(" ","+")}"}.join("&")}").read)
    end
  end
end
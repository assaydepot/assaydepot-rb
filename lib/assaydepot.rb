require "assaydepot/version"
require "open-uri"
require "json"

module AssayDepot
  class Driver
    def initialize(options={})
      @url = options[:url] || "http://localhost:3000/api"
      @search_type = options[:search_type] || "wares"
      @auth_token = options[:auth_token]
    end

    def search(query, facets, page=1)
      params = {}
      params["auth_token"] = @auth_token
      params["q"] = query
      params["page"] = page.to_s
      facets.map do |name,value|
        params["facets[#{name}][]"] = value
      end
      # EXAMPLE: http://localhost:3000/api/wares.json?facets[available_provider_names][]=Assay+Depot
      JSON.parse(open("#{@url}/#{@search_type}.json?#{params.collect { |k,v| "#{k}=#{v.gsub(" ","+")}"}.join("&")}").read)
    end
  end

  class Wares
    # include Enumerable
    # extend Forwardable
    # def_delegators  :private_results, 
    #                 :each, 
    #                 :[], 
    #                 :count, 
    #                 :collect, 
    #                 :map,
    #                 :tap, 
    #                 :<=>, 
    #                 :compact, 
    #                 :each_index, 
    #                 :each_with_index, 
    #                 :empty?, 
    #                 :flatten, 
    #                 :include?, 
    #                 :index, 
    #                 :length, 
    #                 :last, 
    #                 :keep_if,
    #                 :reject,
    #                 :reverse

    attr_accessor :search_page
    attr_accessor :search_query
    attr_accessor :search_facets

    def initialize(options={})
      @search_page = options[:search_page] || 1
      @search_query = options[:search_query] || ""
      @search_facets = options[:search_facets] || {}
    end

    def initialize_copy(source)  
      super
      @search_query = @search_query.dup
      @search_facets = @search_facets.dup
    end

    def query_time
      search_results["query_time"]
    end
    def total
      search_results["total"]
    end
    def page
      search_results["page"]
    end
    def per_page
      search_results["per_page"]
    end
    def facets
      search_results["facets"]
    end

    def page(page)
      result = self.clone
      result.search_page = search_page
      result
    end

    def find(query)
      result = self.clone
      result.search_query = search_query
      result
    end

    def method_missing(sym, *args, &block)
      matcher = sym.to_s.match(/^find_by_(.*)/)
      if(matcher)
        result = self.clone
        result.search_facets[matcher[1]] = args[0]
        result
      end
    end

    def self.find(query)
      self.new.find(query)
    end
    def self.method_missing(sym, *args, &block)
      matcher = sym.to_s.match(/^find_by_(.*)/)
      if(matcher)
        self.new.send(sym, *args, &block)
      end
    end

    private
    def private_results
      search_results["ware_refs"]
    end
    def search_results
      unless @search_results
        @search_results = Driver.new(:auth_token => "1234567890", :search_type => "wares").search(search_query, search_facets, search_page)
      end
      @search_results
    end
  end
end

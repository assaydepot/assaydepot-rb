require 'forwardable'
module AssayDepot
  module DatabaseModel
    module ClassMethods
      def all(options = {})
        self.new.all(options)
      end
    end

    def self.included(base)
      base.include AssayDepot::Model
      base.extend AssayDepot::Model::ClassMethods
      base.extend ClassMethods
    end

    def all(options = {})
      result = self.clone
      result.internal_options = options
      result
    end

    # Overridden from Model
    def internal_results
      unless @internal_results
        @internal_results = JSON.parse(Client.new(endpoint: self.class.endpoint(nil)).get(params: @internal_options))
      end
      @internal_results
    end
  end

  module SearchModel
    module ClassMethods
      # find and where to modify params
      def find(query)
        self.new.find(query)
      end

      def where(conditions={})
        self.new.where(conditions)
      end
    end

    def self.included(base)
      base.extend AssayDepot::Model::ClassMethods
      base.extend ClassMethods
      base.include AssayDepot::Model
      base.include AssayDepot::Pageable

      attr_accessor :search_query
      attr_accessor :search_facets
    end

    def initialize(options={})
      @internal_options = options[:search_options] || { }
      @search_query = options[:search_query] || ""
      @search_facets = options[:search_facets] || { }
    end

    def facets
      internal_results["facets"]
    end

    def find(query)
      result = self.clone
      result.search_query = query
      result
    end

    def where(conditions={})
      result = self.clone
      result.search_facets = self.search_facets ? self.search_facets.merge(conditions) : conditions
      result
    end

    # Overridden from Model
    def internal_results
      unless @internal_results
        results = Client.new(endpoint: self.class.endpoint(nil)).search(query: search_query, facets: search_facets, params: internal_options)
        @internal_results = JSON.parse(results)
      end
      @internal_results
    end
  end

  module Model
    module ClassMethods
      def get_token(client_id, client_secret, site)
        response = Client.new.request(AssayDepot::TokenAuth.endpoint(site), {}, {}, {:username => client_id, :password => client_secret})
        response[AssayDepot::TokenAuth.ref_name]
      end

      def get_endpoint(id, endpoint, format = "json")
        id = id[0] if id && id.kind_of?(Array)
        id ? "#{endpoint}/#{id}.#{format}" : "#{endpoint}.#{format}"
      end

      # HTTP request verbs
      # optional "id" followed by optional hash
      def get(id: nil, params: {}, format: "json")
        AssayDepot.logger.debug "GET id #{id}, params #{params}"
        result = Client.new(endpoint: endpoint(id, format)).get(params: params)
        return JSON.parse(result) if format == "json"
        result
      end

      def put(id: nil, body: nil, params: {}, format: "json")
        AssayDepot.logger.debug "PUT id #{id}, body #{body.to_s}, params #{params}"
        result = Client.new(endpoint: endpoint(id, format)).put( body: body, params: params )
        return JSON.parse(result) if format == "json"
        result
      end

      def patch(id: nil, body: nil, params: {}, format: "json")
        AssayDepot.logger.debug "PATCH id #{id}, body #{body.to_s}, params #{params}"
        result = Client.new(endpoint: endpoint(id, format)).put( body: body, params: params )
        return JSON.parse(result) if format == "json"
        result
      end

      def post(id: nil, body: nil, params: {}, format: "json")
        AssayDepot.logger.debug "POST id #{id}, body #{body.to_s}, params #{params}"
        result = Client.new(endpoint: endpoint(id, format)).post( body: body, params: params )
        return JSON.parse(result) if format == "json"
        result
      end

      def delete(id: nil, body: nil, params: {}, format: "json")
        AssayDepot.logger.debug "DELETE id #{id}, params #{params}"
        result = Client.new(endpoint: endpoint(id, format)).delete(params: params)
        return JSON.parse(result) if format == "json"
        result
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.extend Forwardable
      base.def_delegators  :private_results,
                      :each,
                      :[],
                      :count,
                      :collect,
                      :map,
                      :tap,
                      :<=>,
                      :compact,
                      :each_index,
                      :each_with_index,
                      :empty?,
                      :flatten,
                      :include?,
                      :index,
                      :length,
                      :first,
                      :last,
                      :keep_if,
                      :reject,
                      :reverse

      attr_accessor :internal_options
    end

    def initialize(options={})
      @internal_options = options[:search_options] || { }
    end

    def initialize_copy(source)
      super
      @search_query = @search_query.dup
      @search_facets = @search_facets.dup
    end

    def query_time
      internal_results["query_time"]
    end

    def total
      internal_results["total"]
    end

    def options(options={})
      result = self.clone
      result.internal_options = self.internal_options ? self.internal_options.merge(options) : options
      result
    end

    def private_results
      internal_results[self.class.ref_name]
    end

    # def internal_results
    #   # To be overridden
    #   # If I leave this method in, it gets called, possibly a problem with the order of inclusion
    # end
  end

  module Pageable
    def page
      internal_results["page"]
    end

    def per_page
      internal_results["per_page"]
    end

    def page(page_num)
      options( { "page" => page_num } )
    end

    def per_page(page_size)
      options( { "per_page" => page_size } )
    end
  end
end

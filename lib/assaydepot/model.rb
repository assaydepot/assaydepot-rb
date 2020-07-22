require 'forwardable'
module AssayDepot
  module Model
    module ClassMethods

      def get_token(client_id, client_secret, site)
        response = Client.new.request(AssayDepot::TokenAuth.endpoint(site), {}, {}, {:username => client_id, :password => client_secret})
        response[AssayDepot::TokenAuth.ref_name]
      end

      def get_endpoint( id, endpoint )
        id = id[0] if id && id.kind_of?(Array)
        id ? "#{endpoint}/#{id}.json" : "#{endpoint}.json"
      end

      # find and where to modify params
      def find(query)
        self.new.find(query)
      end

      def where(conditions={})
        self.new.where(conditions)
      end

      # HTTP request verbs
      # optional "id" followed by optional hash
      def get(*id, **params)
        Client.new(:endpoint => endpoint(id)).get(params)
      end

      def put(*id, **params)

        id, body, params = get_variable_args(id, params)
        # puts "id #{id}, body #{body.to_s}, params #{params}"
        Client.new(:endpoint => endpoint(id)).put( body, params )
      end

      def patch(*id, **params)
        id, body, params = get_variable_args(id, params)
        Client.new(:endpoint => endpoint(id)).put( body, params )
      end

      def post(*id, **params)
        id, body, params = get_variable_args(id, params)
        Client.new(:endpoint => endpoint(id)).post( body, params )
      end

      def delete(*id, **params)
        Client.new(:endpoint => endpoint(id)).delete(params)
      end

      def get_variable_args(id, params)

        if (id && id.length > 1 && (id[1].is_a?(Integer) || id[1].is_a?(String)))
          body = params
          params = {}
        elsif (id && id.length > 1)
          body = id[1]
          id = id[0]
        elsif (id && id[0].is_a?(Hash))
          body = id.last
          id = nil
        elsif (id && id.length == 1 && id[0].is_a?(Hash) == false)
          body = params
          id = id[0]
          params = {}
        else
          body = params
          params = {}
          id = nil
        end
        [id, body, params]
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

      attr_accessor :search_query
      attr_accessor :search_facets
      attr_accessor :search_options

      def initialize(options={})
        @search_query = options[:search_query] || ""
        @search_facets = options[:search_facets] || {}
        @search_options = options[:search_options] || {:page => 1}
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

      def page(page_num)
        options( { "page" => page_num } )
      end

      def per_page(page_size)
        options( { "per_page" => page_size } )
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

      def options(options={})
        result = self.clone
        result.search_options = self.search_options ? self.search_options.merge(options) : options
        result
      end

      def private_results
        search_results[self.class.ref_name]
      end
      def search_results
        unless @search_results
          @search_results = Client.new(:endpoint => self.class.endpoint(nil)).search(search_query, search_facets, search_options)
        end
        @search_results
      end
    end
  end
end

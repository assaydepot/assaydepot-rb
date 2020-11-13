require 'forwardable'
module AssayDepot
  module SearchModel
    module ClassMethods
      def find(query)
        self.new.find(query)
      end
  
      def where(conditions={})
        self.new.where(conditions)
      end
  
      def get(id)
        Client.new(:model_type => model_type).get(id)
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
          @search_results = Client.new(:model_type => self.class.model_type).search(search_query, search_facets, search_options)
        end
        @search_results
      end
    end
  end
end

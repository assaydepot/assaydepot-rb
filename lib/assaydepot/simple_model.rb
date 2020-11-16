require 'forwardable'
module AssayDepot
  module SimpleModel
    module ClassMethods
      def all(options={})
        self.new(options)
      end

      def get(id, params={})
        client.get(id, params)
      end

      def client
        Client.new(model_type: model_type)
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.extend Forwardable
      base.attr_accessor :params
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

      def initialize(options={})
        self.params = options
      end

      def initialize_copy(source)
        super
      end

      def query_time
        index_results["query_time"]
      end

      def total
        index_results["total"]
      end

      def private_results
        index_results[self.class.ref_name]
      end

      def index_results
        unless @index_results
          @index_results = self.class.client.index(params)
        end
        @index_results
      end
    end
  end
end

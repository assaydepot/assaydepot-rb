require 'forwardable'
module AssayDepot
  module NestedSimpleModel
    module ClassMethods
    end

    def self.included(base)
      attr_accessor :nested_model_id

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

      def initialize(nested_model_id, options={})
        @nested_model_id = nested_model_id
      end

      def query_time
        index_results["query_time"]
      end

      def private_results
        index_results[self.class.ref_name]
      end

      def index_results
        unless @index_results
          @index_results = client.index
        end
        @index_results
      end

      def client
        NestedClient.new(nested_model_type: self.class.nested_model_type, nested_model_id: nested_model_id, model_type: self.class.model_type)
      end
    end
  end
end

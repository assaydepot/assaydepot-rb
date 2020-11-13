require "open-uri"
require "json"

module AssayDepot
  class NestedClient < ::AssayDepot::Client
    def initialize(options={})
      @model_type = options[:model_type] || "items"
      @nested_model_id = options[:nested_model_id]
      @nested_model_type = options[:nested_model_type] || "dynamic_lists"
    end

    def search_url(params={})
      "#{AssayDepot.url}/#{@nested_model_type}/#{@nested_model_id}/#{@model_type}.json"
    end

    def get_url(id, params={})
      "#{AssayDepot.url}/#{@nested_model_type}/#{@nested_model_id}/#{@model_type}/#{id}.json"
    end
  end
end

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
      format = params.delete(:format)
      format ||= "json"
      "#{AssayDepot.url}/#{@nested_model_type}/#{@nested_model_id}/#{@model_type}.#{format}"
    end

    def get_url(id, params={})
      format = params.delete(:format)
      format ||= "json"
      "#{AssayDepot.url}/#{@nested_model_type}/#{@nested_model_id}/#{@model_type}/#{id}.#{format}"
    end
  end
end

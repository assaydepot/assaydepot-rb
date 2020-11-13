module AssayDepot
  class Provider
    include ::AssayDepot::SearchModel

    def self.model_type
      "providers"
    end
    def self.ref_name
      "provider_refs"
    end
  end
end

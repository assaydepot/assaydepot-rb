module AssayDepot
  class Provider
    include ::AssayDepot::Model

    def self.search_type
      "providers"
    end
    def self.ref_name
      "provider_refs"
    end
  end
end
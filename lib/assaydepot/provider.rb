module AssayDepot
  class Provider
    include Model

    def self.search_type
      "providers"
    end
    def self.ref_name
      "provider_refs"
    end
  end
end
module AssayDepot
  class Provider
    include Model

    def search_type
      "providers"
    end
    def ref_name
      "provider_refs"
    end
  end
end
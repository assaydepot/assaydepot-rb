module AssayDepot
  class Ware
    include Model

    def search_type
      "wares"
    end
    def ref_name
      "ware_refs"
    end
  end
end
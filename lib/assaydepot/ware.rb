module AssayDepot
  class Ware
    include ::AssayDepot::Model

    def self.search_type
      "wares"
    end
    def self.ref_name
      "ware_refs"
    end
  end
end
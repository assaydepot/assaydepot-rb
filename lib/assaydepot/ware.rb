module AssayDepot
  class Ware
    include ::AssayDepot::SearchModel

    def self.model_type
      "wares"
    end
    def self.ref_name
      "ware_refs"
    end
  end
end
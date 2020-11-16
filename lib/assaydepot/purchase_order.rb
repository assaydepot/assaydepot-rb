module AssayDepot
  class PurchaseOrder
    include ::AssayDepot::SimpleModel

    def self.model_type
      "purchase_orders"
    end
    def self.ref_name
      "purchase_orders"
    end
  end
end

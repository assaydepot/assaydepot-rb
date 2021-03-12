module AssayDepot

  class Category
    include ::AssayDepot::SearchModel

    def self.endpoint(id=nil, format="json")
      get_endpoint(id, "categories", format)
    end

    def self.ref_name
      "category_refs"
    end
  end

  class DynamicForm
    include ::AssayDepot::SearchModel

    def self.endpoint(id=nil, format="json")
      get_endpoint(id, "dynamic_forms", format)
    end
  end

  class Info
    include ::AssayDepot::SearchModel

    def self.endpoint(id=nil, format="json")
      get_endpoint(nil, "info", format)
    end
  end

  class Organization
    include ::AssayDepot::SearchModel

    def self.endpoint(id=nil, format="json")
      get_endpoint(id, "organizations", format)
    end
  end

  class QuoteGroup
    include ::AssayDepot::SearchModel

    def self.mine
      get(id: "mine")
    end

    def self.endpoint(id=nil, format="json")
      get_endpoint(id, "quote_groups", format)
    end

    def self.ref_name
      "quote_group_refs"
    end
  end

  class AddNote
    include ::AssayDepot::SearchModel

    def self.endpoint(id, format="json")
      "/quote_groups/#{id}/add_note.#{format}"
    end

    def self.ref_name
      "quote_group_refs"
    end
  end

  class QuotedWare
    include ::AssayDepot::SearchModel

    def self.proposals(id, format="json")
      get(id: "#{id[:id]}/proposals", format: format)
    end

    def self.purchase_orders(id, format="json")
      get(id: "#{id[:id]}/purchase_orders", format: format)
    end

    def self.messages(id, format="json")
      get(id: "#{id[:id]}/messages", format: format)
    end

    def self.endpoint(id=nil, format="json")
      get_endpoint(id, "quoted_wares", format)
    end

    def self.ref_name
      "quoted_ware_refs"
    end
  end

  class Provider
    include ::AssayDepot::SearchModel

    def self.endpoint(id=nil, format="json")
      get_endpoint( id, "providers", format)
    end

    def self.search_type
      "providers"
    end

    def self.ref_name
      "provider_refs"
    end
  end

  class ProviderWare
    include ::AssayDepot::SearchModel

    def self.endpoint(id, format="json")
      "/providers/#{id.is_a?(Array) ? id[0] : id}/wares.#{format}"
    end

    def self.ref_name
      "ware_refs"
    end
  end

  class User
    include ::AssayDepot::SearchModel

    def self.profile
      get(id: "profile")
    end

    def self.endpoint(id=nil, format="json")
      get_endpoint(id == nil || id[0] == nil ? nil : 'profile', "users", format)
    end

    def self.ref_name
      "user_refs"
    end
  end

  class Ware
    include ::AssayDepot::SearchModel

    def self.endpoint(id=nil, format="json")
      get_endpoint( id, "wares", format)
    end

    def self.search_type
      "wares"
    end

    def self.ref_name
      "ware_refs"
    end
  end

  class WareProvider
    include ::AssayDepot::SearchModel

    def self.endpoint(id, format="json")
      if (id.is_a?(Array) && id.length > 1)
        url = "/wares/#{id[0]}/providers/#{id[1]}.#{format}"
      else
        url = "/wares/#{id.is_a?(Array) ? id[0] : id}/providers.#{format}"
      end
      url
    end

    def self.ref_name
      "provider_refs"
    end
  end

  class Webhook
    include ::AssayDepot::SearchModel

    def self.endpoint(id=nil, format="json")
      get_endpoint(id, "webhook_config", format)
    end

    def self.ref_name
      "results"
    end
  end

  class TokenAuth
    include ::AssayDepot::SearchModel

    def self.endpoint(site="", format=nil)
      "#{site}/oauth/token?grant_type=client_credentials"
    end

    def self.ref_name
      "access_token"
    end
  end

  class PurchaseOrder
    include ::AssayDepot::DatabaseModel

    def self.endpoint(id=nil, format="json")
      get_endpoint(id, "purchase_orders", format)
    end

    def self.ref_name
      "purchase_orders"
    end
  end

  class List
    include ::AssayDepot::DatabaseModel

    def self.create(slug, name)
      post(body: { slug: slug, name: name })
    end

    def self.endpoint(id=nil, format="json")
      get_endpoint(id, "dynamic_lists", format)
    end

    def self.ref_name
      "dynamic_lists"
    end
  end

  class ListItem
    include ::AssayDepot::SearchModel

    def self.endpoint(id, format="json")
      if (id.is_a?(Array) && id.length > 1)
        url = "/dynamic_lists/#{id[0]}/items/#{id[1]}.#{format}"
      else
        url = "/dynamic_lists/#{id.is_a?(Array) ? id[0] : id}/items.#{format}"
      end
      url
    end

    def self.ref_name
      "items"
    end
  end
end

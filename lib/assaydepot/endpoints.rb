module AssayDepot

  class Category
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint(id, "categories")
    end

    def self.ref_name
      "category_refs"
    end
  end

  class DynamicForm
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint(id, "dynamic_forms")
    end
  end

  class Info
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint(nil, "info")
    end
  end

  class Organization
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint(id, "organizations")
    end
  end

  class QuoteGroup
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint(id, "quote_groups")
    end

    def self.ref_name
      "quote_group_refs"
    end
  end

  class AddNote
    include ::AssayDepot::Model

    def self.endpoint(id)
      "/quote_groups/#{id}/add_note"
    end

    def self.ref_name
      "quote_group_refs"
    end
  end

  class QuotedWare
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint(id, "quoted_wares")
    end

    def self.ref_name
      "quoted_ware_refs"
    end
  end

  class Provider
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint( id, "providers" )
    end

    def self.search_type
      "providers"
    end

    def self.ref_name
      "provider_refs"
    end
  end

  class ProviderWare
    include ::AssayDepot::Model

    def self.endpoint(id)
      "/providers/#{id.is_a?(Array) ? id[0] : id}/wares.json"
    end

    def self.ref_name
      "ware_refs"
    end
  end

  class User
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint(id == nil || id[0] == nil ? nil : 'profile', "users")
    end

    def self.ref_name
      "user_refs"
    end
  end

  class Ware
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint( id, "wares" )
    end

    def self.search_type
      "wares"
    end

    def self.ref_name
      "ware_refs"
    end
  end

  class WareProvider
    include ::AssayDepot::Model

    def self.endpoint(id)
      if (id.is_a?(Array) && id.length > 1)
        url = "/wares/#{id[0]}/providers/#{id[1]}.json"
      else
        url = "/wares/#{id.is_a?(Array) ? id[0] : id}/providers.json"
      end
      url
    end

    def self.ref_name
      "provider_refs"
    end
  end

  class Webhook
    include ::AssayDepot::Model

    def self.endpoint(id=nil)
      get_endpoint(id, "webhook_config")
    end

    def self.ref_name
      "results"
    end
  end

  class TokenAuth
    include ::AssayDepot::Model

    def self.endpoint(site="")
      "#{site}/oauth/token?grant_type=client_credentials"
    end

    def self.ref_name
      "access_token"
    end
  end
end

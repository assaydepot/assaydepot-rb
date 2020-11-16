module AssayDepot
  class List
    include ::AssayDepot::SimpleModel

    def self.items(id)
      ::AssayDepot::ListItem.new(id)
    end

    def self.create(slug, name)
      client.execute_post(client.search_url, { dynamic_list: { slug: slug, name: name } })
    end

    def self.model_type
      "dynamic_lists"
    end
    def self.ref_name
      "dynamic_lists"
    end
  end
end

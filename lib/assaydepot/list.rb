module AssayDepot
  class List
    include ::AssayDepot::SimpleModel

    # curl --header "Authorization: Bearer $TOKEN" --header "Content-Type: application/json" -X POST --data '{"items": [{"value":"a", "human_readable_value": "A"}, {"value":"b", "human_readable_value": "B"}, {"value":"c", "human_readable_value": "C"}]}' $BASE_URL/api/v2/dynamic_lists/xyz4/items.json

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

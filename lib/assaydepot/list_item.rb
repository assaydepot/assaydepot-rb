module AssayDepot
  class ListItem
    include ::AssayDepot::NestedSimpleModel

    # curl --header "Authorization: Bearer $TOKEN" --header "Content-Type: application/json" -X POST --data '{"items": [{"value":"a", "human_readable_value": "A"}, {"value":"b", "human_readable_value": "B"}, {"value":"c", "human_readable_value": "C"}]}' $BASE_URL/api/v2/dynamic_lists/xyz4/items.json
    # {
    #   "items": [
    #     {
    #       "value": "hand",
    #       "human_readable_value": "Your Hand"
    #     },
    #     {
    #       "value": "oh-god",
    #       "human_readable_value": "Oh god why did I say 9"
    #     },
    #     {
    #       "value": "no-way",
    #       "human_readable_value": "No way, 3 is good enough"
    #     }
    #   ],
    #   "query_time": 0.001552
    # }

    def update(items)
      client.execute_post(client.search_url, {items: items})
    end

    def self.model_type
      "items"
    end

    def self.nested_model_type
      "dynamic_lists"
    end

    def self.ref_name
      "items"
    end
  end
end

module AssayDepot
  module Configurable

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
      self
    end

    CONFIG_KEYS = [
      :url,
      :access_token,
    ] unless defined? CONFIG_KEYS
    attr_accessor *CONFIG_KEYS

    class << self
      def keys
        @keys ||= CONFIG_KEYS
      end
    end
  end
end
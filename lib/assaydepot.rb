require "assaydepot/version"
require "assaydepot/configurable"
require "assaydepot/client"
require "assaydepot/model"
require "assaydepot/ware"
require "assaydepot/provider"

# Twitter.configure do |config|
#   config.consumer_key = YOUR_CONSUMER_KEY
#   config.consumer_secret = YOUR_CONSUMER_SECRET
#   config.oauth_token = YOUR_OAUTH_TOKEN
#   config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
# end

module AssayDepot
  class << self
    include AssayDepot::Configurable
  end

  # Delegate to a AssayDepot::Client
  #
  # @return [AssayDepot::Client]
  def client
    AssayDepot::Client.new(options)
  end
end

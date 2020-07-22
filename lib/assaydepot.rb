puts "yes!"
require "assaydepot/version"
require "assaydepot/configurable"
require "assaydepot/client"
require "assaydepot/model"
require "assaydepot/core"
require "assaydepot/endpoints"
require "assaydepot/event"

module AssayDepot
  class SignatureVerificationError < StandardError
    def initialize(msg="Event not properly signed.", exception_type="custom")
      @exception_type = exception_type
      super(msg)
    end
  end

  class WebhookError < StandardError
    def initialize(msg="Webhook was not applied.", exception_type="custom")
      @exception_type = exception_type
      super(msg)
    end
  end
end
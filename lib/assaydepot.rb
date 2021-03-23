require "assaydepot/version"
require "assaydepot/configurable"
require "assaydepot/client"
require "assaydepot/model"
require "assaydepot/core"
require "assaydepot/endpoints"
require "assaydepot/event"
require "logger"

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

  def self.logger
    @@logger ||= defined?(Rails) ? Rails.logger : ::Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @@logger = logger
  end
end
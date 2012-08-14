module AssayDepot
  class << self
    include ::AssayDepot::Configurable
  end

  # Delegate to a AssayDepot::Client
  #
  # @return [AssayDepot::Client]
  def client
    ::AssayDepot::Client.new(options)
  end
end

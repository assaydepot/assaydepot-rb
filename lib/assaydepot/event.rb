require "openssl"

module AssayDepot
  class Webhook

    def self.construct_event(payload, signature_header, endpoint_secret)
      sig_hash = {}

      # get t=, v0=, v1= components of the signature
      signature_header.split(',').each do |str|
        sig_hash[str.split('=')[0]] = str.split('=')[1]
      end

      mac = OpenSSL::HMAC.hexdigest("SHA256", "#{sig_hash["t"]}0123456789abcdefghijklmnopqrstuvwxyz", payload)
      raise AssayDepot::SignatureVerificationError.new "Event (#{Rails.env}) not properly signed." if Rails.env == 'test' || Rails.env == 'development' && mac != sig_hash["v0"]
      mac = OpenSSL::HMAC.hexdigest("SHA256", "#{sig_hash["t"]}#{endpoint_secret}", payload)
      raise AssayDepot::SignatureVerificationError.new if Rails.env != 'test' && Rails.env != 'development' && mac != sig_hash["v1"]
      raise AssayDepot::SignatureVerificationError.new "Invalid timestamp." if sig_hash["t"].to_i < 5.minutes.ago.to_i
    end
  end
end
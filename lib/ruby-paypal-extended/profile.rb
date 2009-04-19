module PayPalSDK
  
  # This class holds a merchant's API crednetials and PayPal endpoint information
  class Profile
    
    attr_accessor :credentials
    attr_accessor :endpoints
    attr_accessor :client_info
    attr_accessor :proxy_info
    
    # Proxy information of the client environment.
    DEFAULT_PROXY_INFO = {"USE_PROXY" => false, "ADDRESS" => nil, "PORT" => nil, "USER" => nil, "PASSWORD" => nil }
     
    # Creates a new Profile, setting it with the options provided
    # Options are:
    # <tt>credentials</tt> - A hash of user credentials with keys of "USER", "PWD", and "SIGNATURE"
    # <tt>use_production</tt> - Set to true to interact with the production server. Defaults to false
    # <tt>proxy_info</tt> - A hash of proxy server info with keys of "USE_PROXY", "ADDRESS", "PORT", "USER", "PASSWORD"
    def initialize(credentials, use_production = false, proxy_info = nil)
      @credentials = credentials
      @proxy_info = proxy_info || DEFAULT_PROXY_INFO
      
      @endpoints = use_production ? PayPalSDK::Config::PRODUCTION_API_ENDPOINT : PayPalSDK::Config::SANDBOX_API_ENDPOINT
      
      @client_info = {
        "VERSION" => PayPalSDK::Config::CLIENT_VERSION,
        "SOURCE" => PayPalSDK::Config::CLIENT_SOURCE
      }
    end
    
    def use_proxy?
      @proxy_info["USE_PROXY"]
    end
  end
end
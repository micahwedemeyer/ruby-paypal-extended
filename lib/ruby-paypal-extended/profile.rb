module PayPalSDK
  
  # This class holds a merchant's API crednetials and PayPal endpoint information
  class Profile
    
    attr_accessor :credentials
    attr_accessor :endpoints
    attr_accessor :client_info
    attr_accessor :proxy_info
    
    def self.PAYPAL_EC_URL
      @@PAYPAL_EC_URL
    end
    
    def self.PAYPAL_EC_URL=(value)
      @@PAYPAL_EC_URL = value
    end
    
    def self.DEV_CENTRAL_URL
      @@DEV_CENTRAL_URL
    end
    
    def self.DEV_CENTRAL_URL=(value)
      @@DEV_CENTRAL_URL = value
    end
    
    # Proxy information of the client environment.
    DEFAULT_PROXY_INFO = {"USE_PROXY" => false, "ADDRESS" => nil, "PORT" => nil, "USER" => nil, "PASSWORD" => nil }
        
    # Information needed for tracking purposes.
    DEFAULT_CLIENT_INFO = { "VERSION" => "56.0", "SOURCE" => "PayPalRubySDKV1.2.0"}
        
    # endpoint of PayPal server against which call will be made.
    DEFAULT_ENDPOINTS = {"SERVER" => "api-3t.sandbox.paypal.com", "SERVICE" => "/nvp/"}
    
    
    # Redirect URL for Express Checkout 
    @@PAYPAL_EC_URL="https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token="
    #    
    @@DEV_CENTRAL_URL="https://developer.paypal.com"
     
    # Creates a new Profile, setting it with the options provided
    # Options are:
    # <tt>proxy_info</tt>
    # <tt>client_info</tt>
    # ...
    ###############################################################################################################################    
    #    NOTE: Production code should NEVER expose API credentials in any way! They must be managed securely in your application.
    #    To generate a Sandbox API Certificate, follow these steps: https://www.paypal.com/IntegrationCenter/ic_certificate.html
    ###############################################################################################################################
    def initialize(credentials, proxy_info = nil, endpoints = nil, client_info = nil)
      @credentials = credentials
      @proxy_info = proxy_info || DEFAULT_PROXY_INFO
      @endpoints = endpoints || DEFAULT_ENDPOINTS 
      @client_info = client_info || DEFAULT_CLIENT_INFO
    end
    
    def use_proxy?
      @proxy_info["USE_PROXY"]
    end
  end
end
require 'ruby-paypal-extended/paypal_exception'
require 'ruby-paypal-extended/profile'
require 'ruby-paypal-extended/transaction'
require 'ruby-paypal-extended/caller'
require 'ruby-paypal-extended/operations/operation'
require 'ruby-paypal-extended/operations/mass_pay'
require 'ruby-paypal-extended/ipn/notification'

module PayPalSDK
  
  # Various configuration values
  module Config
    # The PayPal NVP API version that this client can talk to.
    CLIENT_VERSION = "56.0"
    
    # The name of this client
    CLIENT_SOURCE = "ruby-paypal-extended"
    
    # The hostname for the sandbox API target
    SANDBOX_API_HOST = "api-3t.sandbox.paypal.com"
    
    # The path for the sandbox API target
    SANDBOX_API_PATH = "/nvp"
    
    # The hostname for the production API target
    PRODUCTION_API_HOST = "api-3t.paypal.com"
    
    # The path for the production API target
    PRODUCTION_API_PATH = "/nvp"
    
    # The URL to the sandbox IPN endpoint
    SANDBOX_IPN_URL = 'https://www.sandbox.paypal.com/cgi-bin/webscr'
    
    # The URL to the productino IPN endpoint
    PRODUCTION_IPN_URL = 'https://www.paypal.com/cgi-bin/webscr'
    
    # The Hashes used by Profile
    SANDBOX_API_ENDPOINT = {"SERVER" => SANDBOX_API_HOST, "SERVICE" => SANDBOX_API_PATH}
    PRODUCTION_API_ENDPOINT = {"SERVER" => PRODUCTION_API_HOST, "SERVICE" => PRODUCTION_API_PATH}
  end
end
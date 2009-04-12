require 'net/http'
require 'net/https'
require 'uri'
require 'cgi'
# The module has a class and a wrapper method wrapping NET:HTTP methods to simplify calling PayPal APIs.

module PayPalSDK   
  class Caller
    attr_reader :ssl_strict
    
    # Headers for ?
    @@headers = {'Content-Type' => 'html/text'}
    
    # Creates a new Caller object.
    #
    # <tt>profile</tt> - A PayPalSDK::Profile object.
    def initialize(profile, ssl_verify_mode=false)
      @ssl_strict = ssl_verify_mode  
        
      @profile = profile
      
      # Some short names for readability
      @pi = @profile.proxy_info
      @cre = @profile.credentials
      @ci = @profile.client_info
      @ep = @profile.endpoints
    end   
    
   
    # This method uses HTTP::Net library to talk to PayPal WebServices. This is the method what merchants should mostly care about.
    # It expects an hash arugment which has the method name and paramter values of a particular PayPal API.
    # It assumes and uses the credentials of the merchant which is the attribute value of credentials of profile class in PayPalSDKProfiles module.
    # It assumes and uses the client information which is the attribute value of client_info of profile class of PayPalSDKProfiles module.
    # It will also work behind a proxy server. If the calls need be to made via a proxy sever, set USE_PROXY flag to true and specify proxy server and port information in the profile class. 
    def call(request_hash)
      req_data = request_post_data(request_hash)
      
     if (@profile.use_proxy?)
        if( @pi["USER"].nil? || @pi["PASSWORD"].nil? )
          http = Net::HTTP::Proxy(@pi["ADDRESS"],@pi["PORT"]).new(@ep["SERVER"], 443)
        else 
          http = Net::HTTP::Proxy(@pi["ADDRESS"],@pi["PORT"],@pi["USER"], @pi["PASSWORD"]).new(@ep["SERVER"], 443)
        end        
      else 
        http = Net::HTTP.new(@ep["SERVER"], 443)                       
      end       
      http.verify_mode    = OpenSSL::SSL::VERIFY_NONE #unless ssl_strict
      http.use_ssl = true;        
    
      contents, unparseddata = http.post2(@ep["SERVICE"], req_data, @headers)    
      data =CGI::parse(unparseddata)          
      transaction = Transaction.new(data)         
    end
    
    # Builds the post data for sending a request to PayPal, converting
    # hash values to CGI request (NVP) format.
    # It expects an hash arugment which has the method name and paramter values of a particular PayPal API.
    def request_post_data(request_hash)
      "#{hash2cgiString(request_hash)}&#{hash2cgiString(@cre)}&#{hash2cgiString(@ci)}"
    end
    
    protected
    
    # Method to convert a hash to a string of name and values delimited by '&' as name1=value1&name2=value2...&namen=valuen.
    def hash2cgiString(h)
      # Order the keys alphabetically. It's not strictly necessary but makes
      # output easier to determine (helps testing)
      # This requires that the keys be strings, since symbols aren't sortable
      h2 = {}
      h.each {|key, value| h2[key.to_s] = value}
      alpha_keys = h2.keys.sort
      
      # Escape all the values first
      alpha_keys.each {|key| h2[key] = CGI::escape(h2[key].to_s) if (h2[key])}
      
      # Create the string
      alpha_keys.collect {|key| "#{key}=#{h2[key]}"}.join('&')
    end
    
  end
end  


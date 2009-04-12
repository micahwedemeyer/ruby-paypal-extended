require 'net/http'
require 'net/https'
require 'uri'

#require 'utils'
# The module has a class and a wrapper method wrapping NET:HTTP methods to simplify calling PayPal APIs.

module PayPalSDKCallers   
  class Caller    
    include PayPalSDKProfiles
    #include PayPalSDKUtils
    attr_reader :ssl_strict
    # to make long names shorter for easier access and to improve readability define the following variables
    @@profile = PayPalSDKProfiles::Profile
    # Proxy server information hash
    @@pi=@@profile.proxy_info
    # merchant credentials hash
    @@cre=@@profile.credentials
    # client information such as version, source hash
    @@ci=@@profile.client_info
    # endpoints of PayPal hash
    @@ep=@@profile.endpoints     
#    @@PayPalLog=PayPalSDKUtils::Logger.getLogger('PayPal.log')    
    # CTOR
    def initialize(ssl_verify_mode=false)
      @ssl_strict = ssl_verify_mode  
      @@headers = {'Content-Type' => 'html/text'}  
      @profile =PayPalSDKProfiles::Profile.new
    end   
    
   
    # This method uses HTTP::Net library to talk to PayPal WebServices. This is the method what merchants should mostly care about.
    # It expects an hash arugment which has the method name and paramter values of a particular PayPal API.
    # It assumes and uses the credentials of the merchant which is the attribute value of credentials of profile class in PayPalSDKProfiles module.
    # It assumes and uses the client information which is the attribute value of client_info of profile class of PayPalSDKProfiles module.
    # It will also work behind a proxy server. If the calls need be to made via a proxy sever, set USE_PROXY flag to true and specify proxy server and port information in the profile class. 
    def call(requesth)   
    # convert hash values to CGI request (NVP) format
      req_data= "#{hash2cgiString(requesth)}&#{hash2cgiString(@@cre)}&#{hash2cgiString(@@ci)}"  
      
     # if (@@pi["USE_PROXY"])
     if (@profile.m_use_proxy)
        if( @@pi["USER"].nil? || @@pi["PASSWORD"].nil? )
          http = Net::HTTP::Proxy(@@pi["ADDRESS"],@@pi["PORT"]).new(@@ep["SERVER"], 443)
        else 
          http = Net::HTTP::Proxy(@@pi["ADDRESS"],@@pi["PORT"],@@pi["USER"], @@pi["PASSWORD"]).new(@@ep["SERVER"], 443)
        end        
      else 
        http = Net::HTTP.new(@@ep["SERVER"], 443)                       
      end       
      http.verify_mode    = OpenSSL::SSL::VERIFY_NONE #unless ssl_strict
      http.use_ssl = true;        
    
      maskedrequest = mask_data(req_data)
#      @@PayPalLog.info "Sent: #{maskedrequest}"  
      contents, unparseddata = http.post2(@@ep["SERVICE"], req_data, @@headers)    
#      @@PayPalLog.info "Received: #{CGI.unescape(unparseddata)}"
      data =CGI::parse(unparseddata)          
      transaction = Transaction.new(data)         
    end    
  end
  # Wrapper class to wrap response hash from PayPal as an object and to provide nice helper methods
  class Transaction       
    def initialize(data)
     @success = data["ACK"].to_s != "Failure"
     @response = data    
   end
    def success?
      @success
    end
    def response
      @response
    end
  end
end  


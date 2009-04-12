module PayPalSDK
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
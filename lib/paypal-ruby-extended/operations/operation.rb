module PayPalSDK
  module Operations
    # Represents a base class method that is not yet implemented.
    class NotImplementedException < PayPalException
    end
    
    # Abstract base class for all the operations
    class Operation
      
      # Executes the operation and returns the response wrapped in
      # a Transaction
      def call(caller)
        caller.call(call_hash)
      end
      
      protected
      
      # Translates this Operation into the Hash expected by Caller
      # Every Operation Class must implement this method
      def call_hash
        raise NotImplementedException.new("Must implement call_hash")
      end
      
    end
  end
end
module PayPalSDK
  module Operations
    
    # Represents an arity mismatch where the number of receipients does
    # not match all the other arguments
    class MassPayArityException < PayPalException
    end
    
    # Represents the MassPay operation
    class MassPay < Operation
      attr_accessor :receiver_identifiers
      attr_accessor :amounts
      attr_accessor :receiver_type
      attr_accessor :currency_code
      attr_accessor :email_subject
      attr_accessor :unique_ids
      attr_accessor :notes
      
      def initialize(
        receiver_identifiers,
        amounts,
        receiver_type = "EmailAddress",
        currency_code = "USD",
        email_subject = nil,
        unique_ids = nil,
        notes = nil
      )
        @receiver_identifiers = receiver_identifiers
        @amounts = amounts
        @receiver_type = receiver_type
        @currency_code = currency_code
        @email_subject = email_subject
        @unique_ids = unique_ids
        @notes = notes
        
        @n_recip = @receiver_identifiers.size
        check_arity
      end
      
      protected
      
      def call_hash
        # Double-check the arity before making the hash
        check_arity
        
        h = {
          :method => "MassPay",
          :receiver_type => @receiver_type,
          :currency_code => @currency_code,
          :email_subject => @email_subject
        }
        
        id_key = @receiver_type == "UserID" ? "l_receiverid" : "l_email"
        
        @receiver_identifiers.each_index do |i|
          h["#{id_key}#{i}".to_sym] = @receiver_identifiers[i]
          h["l_amt#{i}".to_sym] = @amounts[i]
          h["l_uniqueid#{i}".to_sym] = @unique_ids[i] if @unique_ids
          h["l_note#{i}".to_sym] = @notes[i] if @notes
        end
        
        h
      end
      
      def check_arity
        # Sloppy...
        bad_sizes = []
        bad_sizes << "amounts has #{@amounts.size} values" if @amounts.size != @n_recip
        bad_sizes << "unique_ids has #{@unique_ids.size} values" if !@unique_ids.nil? && (@unique_ids.size != @n_recip)
        bad_sizes << "notes has #{@notes.size} values" if !@notes.nil? && (@notes.size != @n_recip)
        
        unless bad_sizes.empty?
          msg = "Arity mismatch: #{@n_recip} user identifiers, but "
          msg += bad_sizes.join(" and")
          raise MassPayArityException.new(msg)
        end
      end
      
    end
  end
end
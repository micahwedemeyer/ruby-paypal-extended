class OperationTest < Test::Unit::TestCase
  include PayPalSDK::Operations
  
  def setup
    @mock_caller = flexmock(:caller)
    
    # We'll use the MassPay operation
    @op = MassPay.new(mass_pay_opts)
  end
  
  def test_call
    vals = @op.send(:call_hash)
    @mock_caller.should_receive(:call).with(vals).once.and_return(true)
    
    @op.call(@mock_caller)
  end
  
  protected
  
  def mass_pay_opts(opts = {})
    {
      :receiver_identifiers => ["1", "2", "3"],
      :receiver_type => "UserID",
      :amounts => [1.00, 5.00, 10.00],
      :currency_code => "USD",
      :unique_ids => ["a", "b", "c"]
    }.merge(opts)
  end
end
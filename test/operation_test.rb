class OperationTest < Test::Unit::TestCase
  include PayPalSDK::Operations
  
  def setup
    @mock_caller = flexmock(:caller)
    
    # We'll use the MassPay operation
    @op = MassPay.new(*mass_pay_args)
  end
  
  def test_call
    vals = @op.send(:call_hash)
    @mock_caller.should_receive(:call).with(vals).once.and_return(true)
    
    @op.call(@mock_caller)
  end
  
  protected
  
  def mass_pay_args
    [
      ["1", "2", "3"],
      [1.00, 5.00, 10.00],
      "UserID",
      "USD",
      nil,
      ["a", "b", "c"],
      nil
    ]
  end
end